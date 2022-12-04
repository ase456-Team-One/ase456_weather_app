import 'package:climate/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChangeUnitsMeasurement should be rendered on the AppBar',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: LocationScreen()),
    ));
    expect(find.byType(Icon), findsWidgets);
  });
}
