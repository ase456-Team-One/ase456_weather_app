import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class Seasons extends StatefulWidget {
  const Seasons({Key key}) : super(key: key);

  @override
  State<Seasons> createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {
  Icon getSeason() {
    DateTime date = DateTime.now();
    DateFormat formatter = DateFormat('MM-dd-yy');
    String formatDate = formatter.format(date);
    final date_array = formatDate.split('-');
    if (int.parse(date_array[0]) >= 3 && int.parse(date_array[0]) < 6) {
      return Icon(
        Icons.filter_vintage_rounded,
        color: Colors.lightGreen,
        size: 40.0,
      );
    } else if (int.parse(date_array[0]) >= 6 && int.parse(date_array[0]) < 9) {
      return Icon(
        Icons.flare_rounded,
        color: Colors.orange,
        size: 40.0,
      );
    } else if (int.parse(date_array[0]) >= 9 && int.parse(date_array[0]) < 12) {
      return Icon(
        Icons.forest_rounded,
        color: Colors.green,
        size: 40.0,
      );
    } else {
      return Icon(
        Icons.sunny,
        color: Colors.grey,
        size: 40.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getSeason(),
    );
  }
}
