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
      // final Map<String, double> current = data['current_weather'];
      Map<String, dynamic> apiResponse = data['current_weather'];
      CurrentWeather currentWeather = CurrentWeather.fromJson(apiResponse);
      // final String weatherDescription =
      //     WeatherCodeInterpretation(current['weathercode']).getter();
      return currentWeather;
      // return '${current['temperature']}°C\n$weatherDescription\n${current['windspeed']} km/h';
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
      // final hourly = data['hourly'];
      Map<String, dynamic> apiResponse = data['hourly'];
      TodayWeather todayWeather = TodayWeather.fromJson(apiResponse);

      // final List<String> weatherToday =
      //     List.generate(hourly['time'].length, (index) {
      //   final rawTime = hourly['time'][index];
      //   final formattedTime = rawTime.substring(rawTime.indexOf('T') + 1);
      //   final String weatherDescription =
      //       WeatherCodeInterpretation(hourly['weathercode'][index]).getter();
      //   return '$formattedTime\t\t\t\t${hourly['temperature_2m'][index]}°C\t\t\t\t$weatherDescription\t\t\t${hourly['windspeed_10m'][index]}km/h';
      // });
      // return weatherToday.join('\n');
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
      // final daily = data['daily'];
      Map<String, dynamic> apiResponse = data['daily'];
      WeekWeather weekWeather = WeekWeather.fromJson(apiResponse);
      // final List<String> weatherWeekly =
      //     List.generate(daily['time'].length, (index) {
      //   final rawTime = daily['time'][index];
      //   final formattedDay = rawTime;
      //   final String weatherDescription =
      //       WeatherCodeInterpretation(daily['weathercode'][index]).getter();
      //   return '$formattedDay\t\t\t\t\t\t${daily['temperature_2m_min'][index]}°C\t\t\t\t\t\t${daily['temperature_2m_max'][index]}°C\t\t\t\t\t\t$weatherDescription';
      // });
      // return weatherWeekly.join('\n');
      return weekWeather;
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}
