
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bloom/main.dart';

void main() {
  testWidgets('App starts at Welcome Page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BloomApp()));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify that our welcome screen is displayed
    expect(find.text('Bloom'), findsWidgets);
    expect(find.text('Let\'s get started'), findsOneWidget);
  });
}
