import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../database/app_database.dart';

class AuthStorageService {
  AuthStorageService._();
  static final AuthStorageService instance = AuthStorageService._();

  static const String _fileName = 'auth_state.json';
  bool? _cachedIsLoggedIn;

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Checks if the user is currently logged in.
  /// If no auth file exists yet, checks the database to see if the user has already
  /// completed onboarding or has existing cycle data.
  Future<bool> isLoggedIn({AppDatabase? db}) async {
    if (_cachedIsLoggedIn != null) {
      return _cachedIsLoggedIn!;
    }

    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(content);
          final loggedIn = data['isLoggedIn'] == true;
          _cachedIsLoggedIn = loggedIn;
          return loggedIn;
        }
      }

      // Fallback for existing users who already onboarded before this service was added
      if (db != null) {
        final user = await (db.select(db.userProfiles)..limit(1)).getSingleOrNull();
        if (user != null && user.name != 'Guest') {
          await setLoggedIn(true);
          return true;
        }

        final cycle = await (db.select(db.cycles)..limit(1)).getSingleOrNull();
        if (cycle != null) {
          await setLoggedIn(true);
          return true;
        }
      }
    } catch (e) {
      debugPrint('AuthStorageService.isLoggedIn error: $e');
    }
    return false;
  }

  /// Persists login status to disk.
  Future<void> setLoggedIn(bool value) async {
    _cachedIsLoggedIn = value;
    try {
      final file = await _getFile();
      final data = {'isLoggedIn': value};
      await file.writeAsString(jsonEncode(data), flush: true);
    } catch (e) {
      debugPrint('AuthStorageService.setLoggedIn error: $e');
    }
  }

  /// Logs the user out.
  Future<void> logout() async {
    _cachedIsLoggedIn = false;
    await setLoggedIn(false);
  }
}
