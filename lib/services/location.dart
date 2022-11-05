import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  /// https://pub.dev/packages/geolocator
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    // https://dart.dev/guides/libraries/futures-error-handling
    try {
      var p = await _determinePosition();
      this.latitude = p.latitude;
      this.longitude = p.longitude;
    } catch (e) {
      print(e);
    }
  }
}
