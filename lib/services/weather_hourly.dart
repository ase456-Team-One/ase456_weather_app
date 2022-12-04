import 'package:intl/intl.dart';

class HourlyTemperature {
  String _temperature;
  String _time;
  String _iconId;
  String _chance_of_rain;

  HourlyTemperature(this._temperature, this._time, this._iconId);

  String get time => _time;
  String get temperature => _temperature;
  String get iconId => _iconId;
  String get chance_of_rain => _chance_of_rain;

  HourlyTemperature.fromJson(Map<String, dynamic> parsedJson) {
    this._time = DateFormat.jm()
        .format(DateTime.fromMillisecondsSinceEpoch(parsedJson['dt'] * 1000));
    this._temperature = parsedJson['main']['temp'].toInt().toString();
    this._iconId = parsedJson['weather'][0]['icon'];
    this._chance_of_rain = (parsedJson['pop'] * 100).toString();
  }
}
