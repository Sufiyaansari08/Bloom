import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/profile/presentation/providers/privacy_security_provider.dart';

class SecurityStorageService {
  SecurityStorageService._();
  static final SecurityStorageService instance = SecurityStorageService._();

  static const String _fileName = 'security_settings.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Loads saved security settings from local disk, falling back to defaults if not found.
  Future<PrivacySecurityState> loadSettings() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final Map<String, dynamic> jsonMap = jsonDecode(content);
          return PrivacySecurityState.fromJson(jsonMap);
        }
      }
    } catch (e) {
      debugPrint('SecurityStorageService.loadSettings error: $e');
    }
    return const PrivacySecurityState();
  }

  /// Persists security settings to local disk.
  Future<void> saveSettings(PrivacySecurityState state) async {
    try {
      final file = await _getFile();
      final jsonString = jsonEncode(state.toJson());
      await file.writeAsString(jsonString, flush: true);
    } catch (e) {
      debugPrint('SecurityStorageService.saveSettings error: $e');
    }
  }
}
