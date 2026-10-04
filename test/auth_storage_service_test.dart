import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:bloom/core/services/auth_storage_service.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('auth_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('AuthStorageService defaults to false when no file or DB', () async {
    final loggedIn = await AuthStorageService.instance.isLoggedIn();
    expect(loggedIn, false);
  });

  test('AuthStorageService saves and retrieves logged in status', () async {
    await AuthStorageService.instance.setLoggedIn(true);
    var loggedIn = await AuthStorageService.instance.isLoggedIn();
    expect(loggedIn, true);

    await AuthStorageService.instance.logout();
    loggedIn = await AuthStorageService.instance.isLoggedIn();
    expect(loggedIn, false);
  });
}
