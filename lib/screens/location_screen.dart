import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'city_screen.dart';

enum Units { imperial, metric }

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
  List hourly;
  String unit = 'imperial';

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData, [dynamic hourlyData]) {
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
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
      hourly = hourlyData;
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
                  buildHourlyWidget(context),
                ],
              ),
            ),
          );
        }, // end of builder
      ),
    );
  }

  Widget buildHourlyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlurryContainer(
        blur: 5,
        height: 130,
        elevation: 0,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8.0),
          children: (hourly != null)
              ? hourly.map((hourlyTemperature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${hourlyTemperature.temperature}\u00B0',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Image.network(
                          'http://openweathermap.org/img/wn/${hourlyTemperature.iconId}@4x.png',
                          width: 36,
                          height: 36,
                        ),
                        Text(
                          '${hourlyTemperature.time}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList()
              : [Text('Error'), Text('Please try again')],
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
            var weatherData = await weather.getLocationWeather();
            updateUI(weatherData);
          },
          child: Icon(
            Icons.near_me,
            size: 50.0,
          ),
        ),
        buildPopUpMenu(context),
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

  Widget buildPopUpMenu(BuildContext context) {
    return PopupMenuButton<Units>(
        // Callback that sets the selected popup menu item.
        onSelected: (Units item) {
          setState(() {
            unit = item.name;
            refetchAndUpdate();
          });
        },
        icon: const Icon(
          Icons.thermostat,
          color: Colors.blue,
          size: 48,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Units>>[
              PopupMenuItem<Units>(
                value: Units.imperial,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        unit == 'imperial'
                            ? Icon(Icons.check, size: 15.0)
                            : SizedBox(
                                width: 15.0,
                              ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Fahrenheit'),
                      ],
                    ),
                    const Text(
                      '\u2109',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              PopupMenuItem<Units>(
                value: Units.metric,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        unit == 'metric'
                            ? Icon(Icons.check, size: 15.0)
                            : SizedBox(
                                width: 15.0,
                              ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Celsius'),
                      ],
                    ),
                    const Text(
                      '\u2103',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ]);
  }

  Future<void> refetchAndUpdate() async {
    var weatherData = await weather.getCityWeather(cityName, unit);
    var hourlyData = await weather.getHourlyForecast(cityName, unit);
    updateUI(weatherData, hourlyData);
  }
}
