import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  final String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<String>> fetchCitySuggestions(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(Uri.parse('$geocodingBaseUrl?name=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        final List<String> suggestions = (data['results'] as List)
            .map<String>((result) =>
                "${result['name']}, ${result['admin1']}, ${result['country']}")
            .toList();
        return suggestions;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForCity(String city) async {
    final response = await http.get(Uri.parse('$geocodingBaseUrl?name=$city'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load weather data for $city');
    }
  }

  Future<String> fetchCurrentWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&current_weather=true&weathercode&timezone=auto');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final current = data['current_weather'];
      final String weatherDescription =
          WeatherCodeInterpretation(current['weathercode']).getter();
      return '${current['temperature']}°C\n$weatherDescription\n${current['windspeed']} km/h';
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> fetchTodayWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&hourly=weathercode,temperature_2m,windspeed_10m&current_weather=true&forecast_days=1');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final hourly = data['hourly'];

      final List<String> weatherToday =
          List.generate(hourly['time'].length, (index) {
        final rawTime = hourly['time'][index];
        final formattedTime = rawTime.substring(rawTime.indexOf('T') + 1);
        final String weatherDescription =
            WeatherCodeInterpretation(hourly['weathercode'][index]).getter();
        return '$formattedTime\t\t\t\t${hourly['temperature_2m'][index]}°C\t\t\t\t$weatherDescription\t\t\t${hourly['windspeed_10m'][index]}km/h';
      });
      return weatherToday.join('\n');
    } else {
      throw Exception('Failed to load today\'s weather data');
    }
  }

  Future<String> fetchWeeklyWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max&current_weather=true&timezone=auto');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final daily = data['daily'];
      final List<String> weatherWeekly =
          List.generate(daily['time'].length, (index) {
        final rawTime = daily['time'][index];
        final formattedDay = rawTime;
        final String weatherDescription =
            WeatherCodeInterpretation(daily['weathercode'][index]).getter();
        return '$formattedDay\t\t\t\t\t\t${daily['temperature_2m_min'][index]}°C\t\t\t\t\t\t${daily['temperature_2m_max'][index]}°C\t\t\t\t\t\t$weatherDescription';
      });
      return weatherWeekly.join('\n');
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}

class WeatherCodeInterpretation {
  final int position;

  WeatherCodeInterpretation(this.position);

  static final Map<int, String> weatherCodes = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Drizzle: Light Intensity',
    53: 'Drizzle: Moderate Intensity',
    55: 'Drizzle: Intense',
    56: 'Freezing Drizzle: Light Intensity',
    57: 'Freezing Drizzle: Intense',
    61: 'Rain: Slight intensity',
    63: 'Rain: Moderate',
    65: 'Rain: Heavy',
    66: 'Freezing Rain: Light Intensity',
    67: 'Freezing Rain: Heavy',
    71: 'Snow fall: Slight',
    73: 'Snow fall: Moderate',
    75: 'Snow fall: Heavy',
    77: 'Snow grains',
    80: 'Rain showers: Slight Intensity',
    81: 'Rain showers: Moderate',
    82: 'Rain showers: Violent',
    85: 'Snow showers: slight',
    86: 'Snow showers: heavy',
    95: 'Thunderstorm: Slight or Moderate',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail',
  };

  String getter() {
    return weatherCodes[position] ?? '';
  }
}
