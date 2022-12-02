import 'package:climate/services/weather_hourly.dart';
import 'package:climate/services/weather_daily.dart';

import 'location.dart';
import 'networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['API_KEY'];
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const openWeatherHourlyURLBase =
    'https://pro.openweathermap.org/data/2.5/forecast/hourly';
const openWeatherDailyURLBase =
    'https://api.openweathermap.org/data/2.5/forecast/daily';

//https://api.openweathermap.org/data/2.5/weather';
// '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric'
class WeatherModel {
  Future<dynamic> getCityWeather(String cityName, String unit) async {
    var str = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=$unit';
    //print(str);
    NetworkHelper networkHelper = NetworkHelper(str);

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getHourlyForecast(String cityName, String unit) async {
    var str = '$openWeatherHourlyURLBase?q=$cityName&appid=$apiKey&units=$unit';
    //print(str);
    NetworkHelper networkHelper = NetworkHelper(str);

    var weatherData = await networkHelper.getData();
    List hourlyForecast = weatherData['list']
        .map((hourly) => HourlyTemperature.fromJson(hourly))
        .toList();
    return hourlyForecast;
  }

  Future<dynamic> getLocationWeather(String unit) async {
    Location location = Location();

    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=$unit');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationHourlyForecast(String unit) async {
    Location location = Location();

    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherHourlyURLBase?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=$unit');

    var weatherData = await networkHelper.getData();
    List hourlyForecast = weatherData['list']
        .map((hourly) => HourlyTemperature.fromJson(hourly))
        .toList();
    return hourlyForecast;
  }

  Future<dynamic> getLocationDailyForecast(String unit) async {
    Location location = Location();

    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherDailyURLBase?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=$unit');

    var weatherData = await networkHelper.getData();
    List dailyForecast = weatherData['list']
        .map((daily) => DailyTemperature.fromJson(daily))
        .toList();
    return dailyForecast;
  }

  Future<dynamic> getDailyForecast(String cityName, String unit) async {
    var str = '$openWeatherDailyURLBase?q=$cityName&appid=$apiKey&units=$unit';

    NetworkHelper networkHelper = NetworkHelper(str);

    var weatherData = await networkHelper.getData();

    List dailyForecast = weatherData['list']
        .map((daily) => DailyTemperature.fromJson(daily))
        .toList();

    return dailyForecast;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
