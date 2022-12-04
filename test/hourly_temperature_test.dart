import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:climate/main.dart';
import 'package:climate/services/weather_hourly.dart';
import 'package:climate/widgets/hourly_temperature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:climate/widgets/change_units_measurement.dart';

void main() {
  testWidgets(
      'HourlyTemperatureWidget should build a ListView inside a BlurryContainer',
      (tester) async {
    List hourlyTestData = [
      new HourlyTemperature('43', '1670101200', '01d'),
      new HourlyTemperature('42', '1670104800', '01d')
    ];
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: HourlyTemperatureWidget(hourly: []),
    )));
    expect(find.byType(BlurryContainer), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
