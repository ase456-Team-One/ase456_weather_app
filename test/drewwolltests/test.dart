import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Text(
            'Wind Speed',
            style: TextStyle(fontSize:25),
          ),
          Transform.rotate(
            angle: (windDirect-180) * math.pi / 180,
            child: Icon(
              Icons.arrow_downward_rounded,
              color: Colors.white,
            ),
          ),
          Text(
            '$windSpeed mph',
            style: TextStyle(fontSize: 40),
          )]);
  }
}


class Seasons extends StatefulWidget {
  String month;
  Seasons(this.month, {Key key}) : super(key: key);

  @override
  State<Seasons> createState() => _SeasonsState(month);
}

class _SeasonsState extends State<Seasons> {
  String month;
  _SeasonsState(this.month);

  Icon monthPicker(String month) {
    if (int.parse(month) >= 3 && int.parse(month) < 6) {
      return Icon(
        Icons.filter_vintage_rounded,
        color: Colors.lightGreen,
        size: 40.0,
      );
    } else if (int.parse(month) >= 6 && int.parse(month) < 9) {
      return Icon(
        Icons.sunny,
        color: Colors.orange,
        size: 40.0,
      );
    } else if (int.parse(month) >= 9 && int.parse(month) < 12) {
      return Icon(
        Icons.forest_rounded,
        color: Colors.green,
        size: 40.0,
      );
    } else {
      return Icon(
        Icons.ac_unit_rounded,
        color: Colors.white,
        size: 40.0,
      );
    }
  }

  Icon getSeason(String month) {
    DateTime date = DateTime.now();
    DateFormat formatter = DateFormat('MM-dd-yy');
    String formatDate = formatter.format(date);
    return monthPicker(month);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getSeason(this.month),
    );
  }
}