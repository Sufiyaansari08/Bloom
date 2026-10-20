import 'package:dio/dio.dart';
import '../services/secure_token_storage.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Avoid attaching bearer token for auth endpoints like login/register/refresh
    final isAuthPublicEndpoint = options.path.contains('/api/auth/login') ||
        options.path.contains('/api/auth/register') ||
        options.path.contains('/api/auth/refresh') ||
        options.path.contains('/api/auth/forgot-password') ||
        options.path.contains('/api/auth/reset-password') ||
        options.path == ApiConstants.healthCheck ||
        options.path == ApiConstants.readyCheck;

    if (!isAuthPublicEndpoint) {
      final token = await SecureTokenStorage.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Catch 401 Unauthorized for automatic token rotation
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/api/auth/refresh')) {
      final refreshToken = await SecureTokenStorage.instance.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final refreshDio = Dio(
            BaseOptions(
              baseUrl: _dio.options.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'Content-Type': 'application/json'},
            ),
          );

          final response = await refreshDio.post(
            ApiConstants.refreshToken,
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['access_token']?.toString();
            final newRefreshToken = response.data['refresh_token']?.toString();

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await SecureTokenStorage.instance.updateTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              // Retry original request with new token
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryRes = await _dio.fetch(err.requestOptions);
              return handler.resolve(retryRes);
            }
          }
        } catch (_) {
          // Token refresh failure: session is invalid
          await SecureTokenStorage.instance.clearSession();
        }
      }
    }

    return handler.next(err);
  }
}
