class DailyTemperature {
  String _temperature;

  DailyTemperature(this._temperature);

  String get temperature => _temperature;

  DailyTemperature.fromJson(Map<String, dynamic> parsedJson) {
    this._temperature = parsedJson['temp']['day'].toInt().toString();
  }
}
