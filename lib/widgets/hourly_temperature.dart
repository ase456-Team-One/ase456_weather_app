/// Owner: Trung Cao
/// Revision date: Dec 3, 2022
/// Feature: Hourly Temperature Forecast
/// Description: HourlyTempartureForecast uses ListView widgets to display the hourly temperature forecasts.

import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class HourlyTemperatureWidget extends StatelessWidget {
  const HourlyTemperatureWidget({
    Key key,
    @required this.hourly,
  }) : super(key: key);

  final List hourly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 6.0),
          child: Text(
            'Hourly Temperature Forecast',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlurryContainer(
            blur: 5,
            height: 150,
            elevation: 0,
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(8.0),
              children: hourly.map((hourlyTemperature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${hourlyTemperature.temperature}\u00B0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Image.network(
                        'http://openweathermap.org/img/wn/${hourlyTemperature.iconId}@4x.png',
                        width: 36,
                        height: 36,
                      ),
                      Text(
                        '${hourlyTemperature.time}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '🌧 ${hourlyTemperature.chance_of_rain}%',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
