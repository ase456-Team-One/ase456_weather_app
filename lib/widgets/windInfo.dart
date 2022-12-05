import 'package:flutter/material.dart';
import 'dart:math' as math;

class Wind extends StatefulWidget {
  //Values are determines by ['wind']['deg'] (wind direction) and ['wind']['speed'] (wind speed) from the weather API
  final double windDirect;
  final double windSpeed;

  Wind(this.windDirect, this.windSpeed, {Key key}) : super(key: key);

  @override
  State<Wind> createState() => _WindState(windDirect, windSpeed);
}

class _WindState extends State<Wind> {
  var windDirect;
  var windSpeed;

  _WindState(this.windDirect, this.windSpeed);

  //Return a Column which formats the values the values for wind speed and wind direction
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        'Wind Speed',
        style: TextStyle(fontSize: 24),
      ),
      //Wind direction arrow
      Row(
        children: [
          Transform.rotate(
            angle: (windDirect - 180) * math.pi / 180,
            child: Icon(
              Icons.arrow_downward_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          Text(
            '$windSpeed mph',
            style: TextStyle(fontSize: 24),
          ),
        ],
      )
    ]);
  }
}
