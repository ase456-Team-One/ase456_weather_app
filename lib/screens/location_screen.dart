import 'package:climate/widgets/change_units_measurement.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import '../widgets/hourly_temperature.dart';
import 'city_screen.dart';

enum Units { imperial, metric }

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather, this.locationHourlyWeather});

  final locationWeather;
  final locationHourlyWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  List hourly;
  String unit = 'imperial';

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather, widget.locationHourlyWeather);
  }

  void updateUI(dynamic weatherData, dynamic hourlyData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature, unit);
      cityName = weatherData['name'];
      hourly = hourlyData;
    });
  }

  void changeUnitMeasurement(String newUnit) {
    setState(() {
      unit = newUnit;
      refetchAndUpdate();
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
                  (hourly != null)
                      ? HourlyTemperatureWidget(hourly: hourly)
                      : SizedBox(),
                ],
              ),
            ),
          );
        }, // end of builder
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            var weatherData = await weather.getLocationWeather(unit);
            var hourlyForecastData =
                await weather.getLocationHourlyForecast(unit);
            updateUI(weatherData, hourlyForecastData);
          },
          child: Icon(
            Icons.near_me,
            size: 50.0,
          ),
        ),
        ChangeUnitsMeasurement(
            changeUnitMeasurement: changeUnitMeasurement, unit: unit),
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
              var weatherData = await weather.getCityWeather(typedName, unit);
              var hourlyData = await weather.getHourlyForecast(typedName, unit);
              updateUI(weatherData, hourlyData);
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

  Future<void> refetchAndUpdate() async {
    var weatherData = await weather.getCityWeather(cityName, unit);
    var hourlyData = await weather.getHourlyForecast(cityName, unit);
    updateUI(weatherData, hourlyData);
  }
}
