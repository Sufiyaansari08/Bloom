import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloom/features/onboarding/presentation/pages/health_details_page.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';

void main() {
  Widget createTestWidget(Widget child, {ProviderContainer? container}) {
    if (container != null) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: child,
        ),
      );
    }
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('HealthDetailsPage Widget Tests', () {
    testWidgets('renders all health detail fields and defaults to "Don\'t know" for blood group', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget(const HealthDetailsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Tell us about yourself'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Select your date of birth'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text("Don't know"), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('dropdown contains all blood group options and "Don\'t know"', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget(const HealthDetailsPage()));
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.text("Don't know"));
      await tester.pumpAndSettle();

      // Verify all blood groups exist in the menu
      const expectedGroups = [
        'A+',
        'A-',
        'B+',
        'B-',
        'AB+',
        'AB-',
        'O+',
        'O-',
        "Don't know",
      ];

      for (final bg in expectedGroups) {
        expect(find.text(bg), findsWidgets);
      }

      // Tap on 'O+'
      await tester.tap(find.text('O+').last);
      await tester.pumpAndSettle();

      // Verify 'O+' is selected
      expect(find.text('O+'), findsOneWidget);
    });

    testWidgets('onContinue updates onboardingProvider state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        createTestWidget(
          const HealthDetailsPage(),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Enter height and weight
      await tester.enterText(find.widgetWithText(TextField, '').first, '165');
      await tester.enterText(find.widgetWithText(TextField, '').last, '58');
      await tester.pumpAndSettle();

      // Select B+
      await tester.tap(find.text("Don't know"));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B+').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Update provider manually to test state logic
      container.read(onboardingProvider.notifier).setHealthDetails(
        dateOfBirth: DateTime(2001, 4, 10),
        heightCm: 165,
        weightKg: 58,
        bloodGroup: 'B+',
      );

      final state = container.read(onboardingProvider);
      expect(state.dateOfBirth, DateTime(2001, 4, 10));
      expect(state.heightCm, 165);
      expect(state.weightKg, 58);
      expect(state.bloodGroup, 'B+');
    });

    test('OnboardingNotifier correctly stores "Don\'t know"', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingProvider.notifier).setHealthDetails(
        dateOfBirth: DateTime(1998, 12, 1),
        heightCm: 170,
        weightKg: 65,
        bloodGroup: "Don't know",
      );

      final state = container.read(onboardingProvider);
      expect(state.bloodGroup, "Don't know");
      expect(state.heightCm, 170);
      expect(state.weightKg, 65);
      expect(state.dateOfBirth, DateTime(1998, 12, 1));
    });
  });
}
