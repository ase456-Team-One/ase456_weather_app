import 'package:flutter/material.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:climate/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather('imperial');
    var hourlyForecastData =
        await WeatherModel().getLocationHourlyForecast('imperial');
    //Josh Lohner - code 12/4/22 | Info:Gets the location and api information for the initial loading screen
    var dailyForecastData =
        await WeatherModel().getLocationDailyForecast('imperial');

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
          locationWeather: weatherData,
          locationHourlyWeather: hourlyForecastData,
          locationDailyWeather: dailyForecastData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
