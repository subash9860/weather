import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/location_model.dart';

class LocationProvider with ChangeNotifier {
  LocationModel? _locationmodel;
  LocationModel? get locationData => _locationmodel;

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
