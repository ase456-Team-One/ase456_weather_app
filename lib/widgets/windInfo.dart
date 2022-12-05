import 'package:flutter/material.dart';
import 'dart:math' as math;

class Wind extends StatefulWidget {
  final double windDirect;
  final double windSpeed;

  Wind(this.windDirect,this.windSpeed, {Key key}) : super(key: key) ;

  @override
  State<Wind> createState() => _WindState(windDirect, windSpeed);
}

class _WindState extends State<Wind> {
  var windDirect;
  var windSpeed;

  _WindState(this.windDirect,this.windSpeed);

  Transform directionArrow() {
    return Transform.rotate(
      angle: (windDirect-180) * math.pi / 180,
      child: Icon(
        Icons.arrow_downward_rounded,
        color: Colors.white,
      ),
    );
  }

  Text windDisplay(double windSpeed) {
    return Text(
      '$windSpeed mph',
      style: TextStyle(fontSize: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Text(
            'Wind Speed',
            style: TextStyle(fontSize:25),
          ),
          directionArrow(),
          windDisplay(windSpeed),
        ]);
  }
}

