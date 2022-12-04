// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:climate/screens/location_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../lib/widgets/Time.dart';
import 'package:climate/main.dart';
import 'package:climate/screens/loading_screen.dart';

void main() {
  // test("Given a time past sunrise and before sunset, when chooseTime() is called then a decorated sun icon is returned", () async {
  //   final Time time = Time(sunsetTime: 18, sunriseTime: 8, currentTime: 5, currentDate: DateFormat.yMd(DateTime.now()).toString(),);
  //
  //
  // });

  testWidgets('Given location screen page, either a sun or moon will be displayed at the top of the page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LocationScreen());
    await tester.pump();

    // Verify that the loading screen is shown.
    expect(find.byType(Time), findsOneWidget);
    // This test would continue on to the main page, but it times out waiting for LocationScreen
  });
}
