import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:flutter/material.dart';
import 'package:climate/screens/loading_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Cloudiness(percentage: 100,),
            Cloudiness(percentage: 50,),
            Cloudiness(percentage: 0,)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Cloudiness extends StatefulWidget {
  final percentage;
  const Cloudiness({this.percentage});

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



