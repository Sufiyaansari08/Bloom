import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/database/app_database.dart';
import 'core/database/database_providers.dart';
import 'core/database/database_seeder.dart';

import 'core/services/notification_service.dart';
import 'core/services/security_storage_service.dart';
import 'features/reminders/presentation/providers/notification_sync_provider.dart';
import 'features/profile/presentation/providers/privacy_security_provider.dart';
import 'features/profile/presentation/widgets/in_app_security_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.instance.initialize();
    NotificationService.instance.onNotificationTapped = (payload) {
      final route =
          (payload != null && payload.isNotEmpty) ? payload : '/reminders';
      appRouter.push(route);
    };

    final launchPayload =
        await NotificationService.instance.getAppLaunchPayload();
    if (launchPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.push(
          launchPayload.isNotEmpty ? launchPayload : '/reminders',
        );
      });
    }
  } catch (e) {
    debugPrint('NotificationService init error in main: $e');
  }

  final initialSecurityState =
      await SecurityStorageService.instance.loadSettings();

  final db = AppDatabase();
  await DatabaseSeeder.seedInitialData(db);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        privacySecurityProvider.overrideWith(
          (ref) => PrivacySecurityNotifier(initialSecurityState),
        ),
      ],
      child: const BloomApp(),
    ),
  );
}

class BloomApp extends ConsumerWidget {
  const BloomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep notification scheduler in sync with user settings and cycle predictions
    ref.watch(notificationSyncProvider);

    return MaterialApp.router(
      title: 'Bloom',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          InAppSecurityGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
