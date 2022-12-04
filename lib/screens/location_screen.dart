import 'package:climate/widgets/change_units_measurement.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import '../widgets/hourly_temperature.dart';
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
  double tempHigh;
  double tempLow;
  double tempFeels;
  double humidity;
  String chance_of_rain;

  //Josh Lohner - code 12/4/22 | Info:Initliazes the List daily variable, and get the Date for the current day
  List daily;
  String dropdownvalue = '0';
  var items = ['Item 1', 'Item 2'];
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
      //Josh Lohner - code 12/4/22 | Info:When the UI is updated, it sets the dailyData object to the daily list
      daily = dailyData;
      double temp = weatherData['main']['temp'].toDouble();
      windSpeed = weatherData['wind']['speed'].toDouble();
      windDirect = weatherData['wind']['deg'].toDouble();
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature, unit);
      cityName = weatherData['name'];
      hourly = hourlyData;
      cloudinessPercent = weatherData['clouds']['all'];
      currentTime = weatherData['dt'];
      sunriseTime = weatherData['sys']['sunrise'];
      sunsetTime = weatherData['sys']['sunset'];
      timeZone = weatherData["timezone"];
      formattedCurrentDay = DateFormat.jm().format(
          DateTime.fromMillisecondsSinceEpoch((currentTime - timeZone) * 1000));
      tempHigh = weatherData['main']['temp_max'].toDouble();
      tempLow = weatherData['main']['temp_min'].toDouble();
      tempFeels = weatherData['main']['feels_like'].toDouble();
      humidity = weatherData['main']['humidity'].toDouble();
      chance_of_rain = hourlyData[0].chance_of_rain;
      dropdownvalue =
          "Today's date (D/M/Y): ${datetime.day}-${datetime.month}-${datetime.year}";
      items[0] =
          "Today's date (D/M/Y): ${datetime.day}-${datetime.month}-${datetime.year}";
      items[1] =
          "Today's date (M/D/Y): ${datetime.month}-${datetime.day}-${datetime.year}";
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
                scrollDirection: Axis.vertical,
                // the scrollable list of widgets
                children: <Widget>[
                  buildBaseAppScreen(constraints, context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildBlurryBox("Humidity", "$humidity"),
                      buildBlurryBox("Chance of Rain", "$chance_of_rain%")
                    ],
                  ),
                  // TODO FINISH WIDGET LIST
                  buildHourlyTemperatureWidget(),
                  //Josh Lohner - code 12/4/22 | Info:Initializes the buildDailyWidget, which provies a scrolling box of information
                  (daily != null) ? buildDailyWidget(context) : SizedBox(),
                ],
              ),
            ),
          );
        }, // end of builder
      ),
    );
  }

  BlurryContainer buildBlurryBox(title, value) {
    return BlurryContainer(
      blur: 5,
      elevation: 0,
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("$title", style: kSmallTextStyle),
          Text("$value", style: kSmallerTextStyle)
        ],
      ),
    );
  }

  SingleChildRenderObjectWidget buildHourlyTemperatureWidget() {
    return (hourly != null)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: HourlyTemperatureWidget(hourly: hourly),
          )
        : SizedBox();
  }

//Josh Lohner - code 12/4/22 | Info:This widget maps the information gotten from calling the weather api, and displays the information for days in a scrolling view
  Widget buildDailyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130.0,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // "AppBar" that's actually just a row at the top of the screen
          buildFakeAppBar(context),
          //Josh Lohner - code 12/4/22 | Info:This is the padding that contains the date information
          // Dylan Gaines - Extracted Method 12/4
          buildDateWidget(),
          SizedBox(
            height: 26.0,
          ),
          // Dylan Gaines - Extracted Method 12/4
          buildMainTemperatureRow(),
          buildWeatherMessage(),
        ],
      ),
    );
  }

  Padding buildWeatherMessage() {
    return Padding(
      padding: EdgeInsets.only(right: 15.0, top: 100.0),
      child: Text(
        '$weatherMessage in $cityName',
        textAlign: TextAlign.right,
        style: kMessageTextStyle,
      ),
    );
  }

  Padding buildMainTemperatureRow() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weatherIcon,
                style: kConditionTextStyle,
                textAlign: TextAlign.left,
              ),
              Text('$temperature°', style: kTempTextStyle),
              Wind(windDirect, windSpeed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBlurryBox("Feels Like", "$tempFeels°"),
              buildBlurryBox("High:", "$tempHigh°"),
              buildBlurryBox("Low:", "$tempLow°"),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildDateWidget() {
    return //Josh Lohner - code 12/4/22 | Info:This is the padding that contains the date information
        Padding(
      padding: EdgeInsets.all(18.0),
      //Josh Lohner - code 12/4/22 | Info:This text object contains the date information formated from the Date object called previously
      child: Center(
        child: DropdownButton(
          value: dropdownvalue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String items) {
            return DropdownMenuItem(
              child: Text(
                items,
                textAlign: TextAlign.center,
              ),
              value: items,
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropdownvalue = newValue;
            });
          },
        ),
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
            size: 26.0,
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
        Seasons(),
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
              //Josh Lohner - code 12/4/22 | Info: When the get weather button is pressed, it calls the api to provide the daily weather information
              var dailyForecast =
                  await weather.getDailyForecast(typedName, unit);
              updateUI(weatherData, hourlyData, dailyForecast);
            }
          },
          child: Icon(
            Icons.location_city,
            size: 26.0,
          ),
        ),
      ],
    );
  }

  Future<void> refetchAndUpdate() async {
    var weatherData = await weather.getCityWeather(cityName, unit);
    var hourlyData = await weather.getHourlyForecast(cityName, unit);
    //Josh Lohner - code 12/4/22 | Info: when the page is updated, it calls api for the daily forecast data to update the UI again
    var dailyData = await weather.getDailyForecast(cityName, unit);
    updateUI(weatherData, hourlyData, dailyData);
  }
}
