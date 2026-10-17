import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bloom/features/welcome/presentation/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage renders blooming flower logo, Bloom title, and personal cycle tracker subtext', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(targetRoute: '/target'),
        ),
        GoRoute(
          path: '/target',
          builder: (context, state) => const Scaffold(
            body: Text('Target Page Destination'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Initial frame of splash
    await tester.pump();
    expect(find.text('Bloom'), findsOneWidget);
    expect(find.text('Your personal cycle tracker'), findsOneWidget);
    expect(find.byIcon(Icons.local_florist), findsOneWidget);

    // Advance animation to settle navigation to target
    await tester.pumpAndSettle();
    expect(find.text('Target Page Destination'), findsOneWidget);
  });
}
