import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:intl/intl.dart';
import '../widgets/windInfo.dart';
import '../widgets/seasons.dart';
import 'city_screen.dart';
import '../widgets/cloudiness.dart';
import '../widgets/Time.dart';

enum Units { imperial, metric }

class LocationScreen extends StatefulWidget {
  LocationScreen({
    this.locationWeather,
    this.locationHourlyWeather,
    this.locationDailyWeather,
  });

  final locationWeather;
  final locationHourlyWeather;
  final locationDailyWeather;

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
  int cloudinessPercent;
  int currentTime;
  int sunriseTime;
  int sunsetTime;
  int timeZone;
  DateTime currentDay;
  String formattedCurrentDay;
  double windSpeed;
  double windDirect;
  List daily;
  DateTime datetime = DateTime.now();

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather, widget.locationHourlyWeather,
        widget.locationDailyWeather);
  }

  void updateUI(dynamic weatherData, dynamic hourlyData, dynamic dailyData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        cloudinessPercent = 404;
        currentTime = 404;
        sunriseTime = 404;
        sunsetTime = 404;
        timeZone = 404;
        formattedCurrentDay = "Day not Found";
        return;
      }
      daily = dailyData;
      double temp = weatherData['main']['temp'];
      windSpeed = weatherData['wind']['speed'];
      windDirect = weatherData['wind']['deg'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
      hourly = hourlyData;
      cloudinessPercent = weatherData['clouds']['all'];
      currentTime = weatherData['dt'];
      sunriseTime = weatherData['sys']['sunrise'];
      sunsetTime = weatherData['sys']['sunset'];
      timeZone = weatherData["timezone"];
      formattedCurrentDay = DateFormat.jm().format(
          DateTime.fromMillisecondsSinceEpoch((currentTime - timeZone) * 1000));
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
                  (daily != null) ? buildDailyWidget(context) : SizedBox(),
                  (hourly != null) ? buildHourlyWidget(context) : SizedBox(),
                ],
              ),
            ),
          );
        }, // end of builder
      ),
    );
  }

  Widget buildDailyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: daily.map((
            dailyTemperature,
          ) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 100.0, vertical: 3.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Text("Daily Temperature: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500)),
                      Text(
                        '${dailyTemperature.temperature}\u00B0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
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
          children: hourly.map((hourlyTemperature) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
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
          }).toList(),
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
            padding: EdgeInsets.only(right: 15.0),
            child: Text(
              "Today's date (D/M/Y): ${datetime.day}-${datetime.month}-${datetime.year}",
              textAlign: TextAlign.center,
              style: kMessageTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  '$temperature°',
                  style: kTempTextStyle,
                ),
                Wind(windDirect, windSpeed),
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
            var dailyForecastData =
                await weather.getLocationDailyForecast(unit);
            updateUI(weatherData, hourlyForecastData, dailyForecastData);
          },
          child: Icon(
            Icons.near_me,
            size: 50.0,
          ),
        ),
        Cloudiness(
          percentage: cloudinessPercent,
        ),
        Time(
          currentTime: currentTime,
          sunriseTime: sunriseTime,
          sunsetTime: sunsetTime,
          currentDate: formattedCurrentDay,
        ),
        buildPopUpMenu(context),
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
              var weatherData = await weather.getCityWeather(typedName, unit);
              var hourlyData = await weather.getHourlyForecast(typedName, unit);
              var dailyForecast =
                  await weather.getDailyForecast(typedName, unit);
              updateUI(weatherData, hourlyData, dailyForecast);
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
    var dailyData = await weather.getDailyForecast(cityName, unit);
    updateUI(weatherData, hourlyData, dailyData);
  }
}
