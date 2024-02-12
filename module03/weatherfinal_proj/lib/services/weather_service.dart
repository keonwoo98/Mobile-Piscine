import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherfinal_proj/models/weather_models.dart';

class WeatherService {
  final String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  final String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  String _capitalize(String input) =>
      input.isEmpty ? '' : '${input[0].toUpperCase()}${input.substring(1)}';

  Future<List<String>> fetchCitySuggestions(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(Uri.parse('$geocodingBaseUrl?name=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        final List<String> suggestions = (data['results'] as List)
            .map<String>((result) =>
                '${result['name']}, ${result['admin1']}, ${result['country']}')
            .toList();
        return suggestions;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForCity(String searchText) async {
    final parts = searchText.split(', ');
    final city = _capitalize(parts[0]);
    String country = '';
    String region = '';

    final Uri uri;

    if (searchText.contains(',')) {
      country = _capitalize(parts.last);
      region = _capitalize(parts[1]);
      uri = Uri.parse(
          '$geocodingBaseUrl?name=$city&admin1=$region&country=$country&format=json');
    } else {
      uri = Uri.parse('$geocodingBaseUrl?name=$city&format=json');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      final List<dynamic> filteredResults = results.where((result) {
        final bool matchesCity = _capitalize(result['name']) == city;
        final bool matchesRegion = searchText.contains(',')
            ? _capitalize(result['admin1']) == region
            : true;
        final bool matchesCountry = searchText.contains(',')
            ? _capitalize(result['country']) == country
            : true;
        return matchesCity && (matchesRegion || matchesCountry);
      }).toList();
      if (filteredResults.isNotEmpty) {
        return filteredResults.first;
      } else {
        throw Exception('No matching weather data found from $city');
      }
    } else {
      throw Exception('Failed to load weather data from $city');
    }
  }

  Future<CurrentWeather> fetchCurrentWeather(
      double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&current_weather=true&weathercode&timezone=auto');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> apiResponse = data['current_weather'];
      CurrentWeather currentWeather = CurrentWeather.fromJson(apiResponse);
      return currentWeather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<TodayWeather> fetchTodayWeather(
      double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&hourly=weathercode,temperature_2m,windspeed_10m&current_weather=true&forecast_days=1');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> apiResponse = data['hourly'];
      TodayWeather todayWeather = TodayWeather.fromJson(apiResponse);
      return todayWeather;
    } else {
      throw Exception('Failed to load today\'s weather data');
    }
  }

  Future<WeekWeather> fetchWeeklyWeather(
      double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max&current_weather=true&timezone=auto');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> apiResponse = data['daily'];
      WeekWeather weekWeather = WeekWeather.fromJson(apiResponse);
      return weekWeather;
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}
