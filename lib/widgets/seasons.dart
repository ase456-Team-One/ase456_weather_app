import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class Seasons extends StatefulWidget {
  const Seasons({Key key}) : super(key: key);

  @override
  State<Seasons> createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {
  //Parameter is the month determined by DateTime.now()
  Icon monthPicker(String month) {
    //Determine what range of months the value for month lies within and return an Icon specific to the season which those months represent
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

  //Called by the build function to determine the current date
  Icon getSeason() {
    DateTime date = DateTime.now();
    DateFormat formatter = DateFormat('MM-dd-yy');
    String formatDate = formatter.format(date);
    //Turn string for date retrieved by DateTime.now() into array
    final date_array = formatDate.split('-');
    //Pass the month value (index 0 in date_array) to monthPicker()
    return monthPicker(date_array[0]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getSeason(),
    );
  }
}
