import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

class Cloudiness extends StatefulWidget {
  final percentage;
  const Cloudiness({Key key, this.percentage}) : super(key: key);

  @override
  State<Cloudiness> createState() => _CloudinessState();
}

//
class _CloudinessState extends State<Cloudiness> {
  //Selects cloud color according to percentage passed in
  chooseColor() {
    if (widget.percentage == 100) return Colors.black45;
    if (widget.percentage < 100) return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DecoratedIcon(
          icon: Icon(
            Icons.cloud,
            //Cloud color is chosen based on percentage
            color: chooseColor(),
            size: 26,
          ),
          decoration: IconDecoration(
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black,
                offset: Offset(5, 5),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        //Displays Cloudiness Percentage to the right of the cloud
        Text(
          "${widget.percentage}%",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ],
    );
  }
}