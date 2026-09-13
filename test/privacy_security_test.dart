import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/features/profile/presentation/pages/privacy_security_page.dart';
import 'package:bloom/features/profile/presentation/providers/privacy_security_provider.dart';
import 'package:bloom/features/profile/presentation/providers/in_app_lock_runtime_provider.dart';
import 'package:bloom/features/profile/presentation/widgets/pattern_lock_widget.dart';
import 'package:bloom/features/profile/presentation/widgets/in_app_lock_screen.dart';
import 'package:bloom/features/profile/presentation/widgets/in_app_security_gate.dart';

void main() {
  group('In-App Security Suite Tests', () {
    testWidgets(
        'PrivacySecurityPage displays App Lock, Privacy Blur, and Discrete Notifications',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PrivacySecurityPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Title
      expect(find.text('Privacy & Security'), findsOneWidget);

      // Section 1: Security
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('App Lock'), findsOneWidget);
      expect(find.text('None'), findsOneWidget); // default is None
      expect(find.text('Privacy Blur in App Switcher'), findsOneWidget);
      expect(find.text('Discrete Notifications'), findsOneWidget);

      // Section 2: Privacy
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('AI data usage'), findsOneWidget);
      expect(find.text('Analytics / data sharing'), findsOneWidget);
      expect(find.text('Personalized recommendations'), findsOneWidget);

      // Section 3: Your Data
      expect(find.text('Your Data'), findsOneWidget);
      expect(find.text('Export my data'), findsOneWidget);
      expect(find.text('Delete tracking data'), findsOneWidget);
      expect(find.text('Delete account'), findsOneWidget);

      // Section 4: Account Security
      expect(find.text('Account Security'), findsOneWidget);
      expect(find.text('Active devices'), findsOneWidget);
      expect(find.text('Sign out from all devices'), findsOneWidget);
    });

    testWidgets('PatternLockWidget records gesture and completes pattern',
        (tester) async {
      List<int>? completedPattern;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PatternLockWidget(
                size: 300,
                onPatternComplete: (pattern) {
                  completedPattern = pattern;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Drag across top row (dots 0, 1, 2)
      final widgetCenter = tester.getCenter(find.byType(PatternLockWidget));
      // Top left dot is around (widgetCenter.dx - 100, widgetCenter.dy - 100)
      final start = Offset(widgetCenter.dx - 100, widgetCenter.dy - 100);
      final middle = Offset(widgetCenter.dx, widgetCenter.dy - 100);
      final end = Offset(widgetCenter.dx + 100, widgetCenter.dy - 100);

      final gesture = await tester.startGesture(start);
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(middle);
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(end);
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(completedPattern, isNotNull);
      expect(completedPattern!.length, greaterThanOrEqualTo(2));
    });

    testWidgets('InAppLockScreen unlocks upon correct PIN', (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container = ProviderContainer(),
          child: const MaterialApp(
            home: InAppLockScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Set PIN to 1234 and lock
      container.read(privacySecurityProvider.notifier).setPin('1234');
      container.read(inAppLockRuntimeProvider.notifier).lock();
      expect(container.read(inAppLockRuntimeProvider).isLocked, isTrue);

      // Enter correct PIN: 1, 2, 3, 4
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();

      // Verified and unlocked!
      expect(container.read(inAppLockRuntimeProvider).isLocked, isFalse);
    });

    testWidgets('InAppSecurityGate reveals content when unlocked',
        (tester) async {
      late ProviderContainer container;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container = ProviderContainer(),
          child: const MaterialApp(
            home: InAppSecurityGate(
              child: Scaffold(
                body: Text('Protected Secret Health Data'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state is None -> Protected Content is visible
      expect(find.text('Protected Secret Health Data'), findsOneWidget);

      // Lock with PIN
      container.read(privacySecurityProvider.notifier).setPin('1234');
      container.read(inAppLockRuntimeProvider.notifier).lock();
      await tester.pumpAndSettle();

      // Lock screen covers the content
      expect(find.text('Enter your 4-digit PIN to unlock'), findsOneWidget);

      // Unlock
      container.read(inAppLockRuntimeProvider.notifier).unlock();
      await tester.pumpAndSettle();

      expect(find.text('Enter your 4-digit PIN to unlock'), findsNothing);
      expect(find.text('Protected Secret Health Data'), findsOneWidget);
    });
  });
}
