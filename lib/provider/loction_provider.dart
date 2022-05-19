import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../model/location_model.dart';

class LocationProvider with ChangeNotifier {
  LocationModel? _locationmodel;
  LocationModel? get locationData => _locationmodel;

  String prefData = '';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getLocationName() async {
    final pref = await SharedPreferences.getInstance();
    prefData = pref.getString("locationName") ?? '';
    if (prefData.isNotEmpty) {
      getWeatherByLocation(prefData);
    } else {
      _determinePosition().then((position) =>
          getWeatherByPosition(position.latitude, position.longitude));
      // Provider.of<LocationProvider>(context, listen: false)
      // .getWeatherByPosition(position.latitude, position.longitude));
    }
    notifyListeners();
  }

  Future<void> setLoctionName(String locName) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("locationName", locName);
    print(pref.getString("locationName"));
  }

  // get wheather data from api by lat and lng
  Future<void> getWeatherByPosition(double lat, double lng) async {
    final url =
        'http://api.weatherapi.com/v1/current.json?key=1bc0383d81444b58b1432929200711&q=$lat,$lng';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      _locationmodel = LocationModel(
        tempC: extractedData['current']['temp_c'] as double,
        conditionText: extractedData['current']['condition']['text'] as String,
        iconUrl: extractedData['current']['condition']['icon'],
      );

      notifyListeners();
    }
  }

  // get location data from api by location name
  Future<void> getWeatherByLocation(String locationName) async {
    final url =
        'http://api.weatherapi.com/v1/current.json?key=1bc0383d81444b58b1432929200711&q=$locationName';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);

      _locationmodel = LocationModel(
        tempC: extractedData['current']['temp_c'] as double,
        conditionText: extractedData['current']['condition']['text'] as String,
        iconUrl: extractedData['current']['condition']['icon'],
      );
      notifyListeners();
    }
  }
}
