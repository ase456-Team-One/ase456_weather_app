// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:climate/main.dart';
import 'package:climate/screens/loading_screen.dart';

void main() {
  testWidgets('Simple Example Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pump();

    // Verify that the loading screen is shown.
    expect(find.byType(LoadingScreen), findsOneWidget);
    // This test would continue on to the main page, but it times out waiting for LocationScreen
  });
}
