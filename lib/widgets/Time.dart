import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

class Time extends StatefulWidget {
  final currentTime;
  final sunsetTime;
  final sunriseTime;
  final String currentDate;

  const Time(
      {Key key,
      this.currentTime,
      this.sunriseTime,
      this.sunsetTime,
      this.currentDate})
      : super(key: key);

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  //Shows either Sun or Moon Icon depending on Time of selected Location
  chooseTime() {
    if (widget.currentTime > widget.sunriseTime &&
        widget.currentTime < widget.sunsetTime) {
      return DecoratedIcon(
        icon: Icon(Icons.sunny, size: 26, color: Colors.amber),
        decoration: IconDecoration(
          shadows: [
            Shadow(
              blurRadius: 8,
              color: Colors.amber.shade700,
            ),
          ],
        ),
      );
    } else {
      return DecoratedIcon(
        icon: Icon(Icons.nightlight_round_sharp, size: 26, color: Colors.white),
        decoration: IconDecoration(
          shadows: [
            Shadow(blurRadius: 6, color: Colors.white),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        chooseTime(),
        SizedBox(
          width: 10,
        ),
        //Displays
        Text(
          "${widget.currentDate}",
        ),
      ],
    );
  }
}
