import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherfinal_proj/services/geolocation_service.dart';
import 'package:weatherfinal_proj/services/weather_service.dart';

class MyAppState extends ChangeNotifier {
  final GeolocationService _geolocationService = GeolocationService();
  final WeatherService _weatherService = WeatherService();

  bool geolocationPermError = false;
  String currentWeather = 'Currently';
  String todayWeather = 'Today';
  String weeklyWeather = 'Weekly';
  List<String> citySuggestions = [];
  String city = '';
  String region = '';
  String country = '';
  String error = '';

  Future<void> updateWeatherForCurrentLocation() async {
    _resetErrorState();
    try {
      final position = await _geolocationService.getGeolocation();
      await _updateLocationAndWeather(position.latitude, position.longitude);
    } catch (e) {
      _handleGeolocationError();
    }
  }

  Future<void> fetchWeatherForCity(String searchText) async {
    _resetLocationState();
    try {
      final data = await _weatherService
          .fetchWeatherForCity(searchText.split(',')[0].trim());
      if (_isValidData(data)) {
        await _updateLocationAndWeatherFromCityData(data['results'][0]);
      } else {
        _handleNotFoundError();
      }
    } catch (e) {
      _handleServiceConnectionError();
    }
  }

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      citySuggestions = [];
      notifyListeners();
      return;
    }
    citySuggestions = await _weatherService.fetchCitySuggestions(query);
    notifyListeners();
  }

  void _resetErrorState() {
    geolocationPermError = false;
    error = '';
  }

  void _resetLocationState() {
    city = '';
    region = '';
    country = '';
    _resetErrorState();
  }

  bool _isValidData(Map<String, dynamic> data) {
    return data['results'] != null && data['results'].isNotEmpty;
  }

  Future<void> _updateLocationAndWeather(
      double latitude, double longitude) async {
    await _fetchWeatherData(latitude, longitude);
    await _updateLocationFromCoordinates(latitude, longitude);
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    try {
      currentWeather =
          await _weatherService.fetchCurrentWeather(latitude, longitude);
      todayWeather =
          await _weatherService.fetchTodayWeather(latitude, longitude);
      weeklyWeather =
          await _weatherService.fetchWeeklyWeather(latitude, longitude);
      notifyListeners();
    } catch (e) {
      _handleServiceConnectionError();
    }
  }

  Future<void> _updateLocationFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    city = placemarks[0].locality!;
    region = placemarks[0].administrativeArea!;
    country = placemarks[0].country!;
    notifyListeners();
  }

  Future<void> _updateLocationAndWeatherFromCityData(
      Map<String, dynamic> data) async {
    await _fetchWeatherData(data['latitude'], data['longitude']);
    city = data['name'] ?? '';
    region = data['admin1'] ?? '';
    country = data['country'] ?? '';
    notifyListeners();
  }

  void _handleGeolocationError() {
    geolocationPermError = true;
    error =
        'Geolocation is not available, please enable it in your App settings';
    notifyListeners();
  }

  void _handleNotFoundError() {
    geolocationPermError = true;
    error =
        'Could not find any result for the supplied address or coordinates.';
    notifyListeners();
  }

  void _handleServiceConnectionError() {
    geolocationPermError = true;
    error =
        'The service connection is lost. Please check your internet connection or try again later.';
    notifyListeners();
  }
}
