import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/services/secure_token_storage.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../../core/database/app_database.dart';
import 'package:drift/drift.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  const AuthResult({
    required this.isSuccess,
    this.errorMessage,
    this.data,
  });

  factory AuthResult.success([Map<String, dynamic>? data]) => AuthResult(
        isSuccess: true,
        data: data,
      );

  factory AuthResult.failure(String message) => AuthResult(
        isSuccess: false,
        errorMessage: message,
      );
}

class AuthApiService {
  AuthApiService._();
  static final AuthApiService instance = AuthApiService._();

  final Dio _dio = ApiClient.instance.dio;

  /// Register a new account with email, password, and display name.
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    AppDatabase? db,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final accessToken = data['access_token']?.toString();
        final refreshToken = data['refresh_token']?.toString();
        final user = data['user'] as Map<String, dynamic>?;
        final userId = user?['id']?.toString();

        if (accessToken != null && refreshToken != null) {
          await SecureTokenStorage.instance.saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            email: email.trim(),
          );

          await AuthStorageService.instance.setLoggedIn(true);

          // Update local profile with the official backend ID if provided
          if (db != null && userId != null) {
            try {
              final existingProfile = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
              if (existingProfile != null) {
                await (db.update(db.userProfiles)..where((tbl) => tbl.id.equals(existingProfile.id))).write(
                  UserProfilesCompanion(
                    email: Value(email.trim()),
                    name: Value(name.trim()),
                    isSynced: const Value(true),
                  ),
                );
              }
            } catch (e) {
              debugPrint('Failed to link local profile ID: $e');
            }
          }

          return AuthResult.success(data);
        }
      }
      return AuthResult.failure('Unexpected server response during registration');
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e, fallback: 'Registration failed');
      return AuthResult.failure(msg);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// Log in with email and password.
  Future<AuthResult> login({
    required String email,
    required String password,
    AppDatabase? db,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final accessToken = data['access_token']?.toString();
        final refreshToken = data['refresh_token']?.toString();
        final user = data['user'] as Map<String, dynamic>?;
        final userId = user?['id']?.toString();

        if (accessToken != null && refreshToken != null) {
          await SecureTokenStorage.instance.saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            email: email.trim(),
          );

          await AuthStorageService.instance.setLoggedIn(true);

          return AuthResult.success(data);
        }
      }
      return AuthResult.failure('Unexpected login response');
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e, fallback: 'Invalid email or password');
      return AuthResult.failure(msg);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// Request password reset instructions / OTP token.
  Future<AuthResult> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email.trim()},
      );

      if (response.statusCode == 200) {
        return AuthResult.success(response.data as Map<String, dynamic>?);
      }
      return AuthResult.failure('Failed to send reset instructions');
    } on DioException catch (e) {
      return AuthResult.failure(_extractErrorMessage(e, fallback: 'Failed to request password reset'));
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// Revoke current refresh token session and log out locally.
  Future<void> logout() async {
    try {
      final refreshToken = await SecureTokenStorage.instance.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dio.post(
          ApiConstants.logout,
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (e) {
      debugPrint('Logout remote revocation error (ignored): $e');
    } finally {
      await SecureTokenStorage.instance.clearSession();
      await AuthStorageService.instance.setLoggedIn(false);
    }
  }

  /// Irrevocably expunges user account and deletes all cloud records.
  Future<AuthResult> deleteAccount({required String password}) async {
    try {
      final response = await _dio.delete(
        ApiConstants.deleteAccount,
        data: {
          'confirmation': 'DELETE',
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        await SecureTokenStorage.instance.clearSession();
        await AuthStorageService.instance.setLoggedIn(false);
        return AuthResult.success(response.data as Map<String, dynamic>?);
      }
      return AuthResult.failure('Could not delete account');
    } on DioException catch (e) {
      return AuthResult.failure(_extractErrorMessage(e, fallback: 'Account deletion failed'));
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  String _extractErrorMessage(DioException e, {required String fallback}) {
    if (e.response?.data is Map) {
      final map = e.response!.data as Map;
      if (map['error'] != null) return map['error'].toString();
      if (map['message'] != null) return map['message'].toString();
    }
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot reach Bloom server. Please check your network connection.';
    }
    return fallback;
  }
}
