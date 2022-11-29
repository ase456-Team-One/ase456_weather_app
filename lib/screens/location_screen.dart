import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import '../widgets/windInfo.dart';
import '../widgets/seasons.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  double windSpeed;
  double windDirect;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      windSpeed = weatherData['wind']['speed'];
      windDirect = weatherData['wind']['deg'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: buildBoxDecoration(),
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: ListView(
                // the scrollable list of widgets
                children: <Widget>[
                  buildBaseAppScreen(constraints, context),
                  // TODO widgets/widget-returning-methods go here
                  buildExampleWidget(context),
                ],
              ),
            ),
          );
        }, // end of builder
      ),
    );
  }

  Container buildExampleWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Theme.of(context).backgroundColor,
      child: Placeholder(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Placeholder for New Widgets',
            style: kMessageTextStyle,
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/location_background.jpg'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
      ),
    );
  }

  Widget buildBaseAppScreen(BoxConstraints constraints, BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: constraints.maxHeight),
      // Initial View (looks like base app)
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // "AppBar" that's actually just a row at the top of the screen
          buildFakeAppBar(context),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  '$temperature°',
                  style: kTempTextStyle,
                ),
                Wind(windDirect,windSpeed),
                Text(
                  weatherIcon,
                  style: kConditionTextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Text(
              '$weatherMessage in $cityName',
              textAlign: TextAlign.right,
              style: kMessageTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Row buildFakeAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: () async {
            var weatherData = await weather.getLocationWeather();
            updateUI(weatherData);
          },
          child: Icon(
            Icons.near_me,
            size: 50.0,
          ),
        ),
        Seasons(),
        TextButton(
          onPressed: () async {
            var typedName = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CityScreen();
                },
              ),
            );
            if (typedName != null) {
              var weatherData = await weather.getCityWeather(typedName);
              updateUI(weatherData);
            }
          },
          child: Icon(
            Icons.location_city,
            size: 50.0,
          ),
        ),
      ],
    );
  }
}
