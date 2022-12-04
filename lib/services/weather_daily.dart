//Josh Lohner - code 12/4/22 | Info: This class serves as a template for the weather api to log the neccessary information. It gets and sets the temperature variable
class DailyTemperature {
  String _temperature;

  DailyTemperature(this._temperature);

  String get temperature => _temperature;
//Josh Lohner - code 12/4/22 | Info:Returns information from the json object
  DailyTemperature.fromJson(Map<String, dynamic> parsedJson) {
    this._temperature = parsedJson['temp']['day'].toInt().toString();
  }
}
