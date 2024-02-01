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
        return []; // 'results'가 null일 경우 빈 리스트 반환
      }
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForCity(String city) async {
    // 예시에서는 간단한 구현으로, 실제 API에서는 도시 이름으로 직접 날씨 정보를 조회하는 기능이 제공되지 않을 수 있습니다.
    // 실제 구현에서는 도시 이름을 기반으로 좌표를 찾고, 해당 좌표에 대한 날씨 정보를 조회하는 방식이 필요할 수 있습니다.
    final response = await http.get(Uri.parse('$geocodingBaseUrl?name=$city'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // API 응답 구조에 따라 날씨 데이터 추출
      return data; // 여기서는 예시로 간단히 처리합니다.
    } else {
      throw Exception('Failed to load weather data for $city');
    }
  }

  Future<String> fetchCurrentWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&current_weather=true');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final current = data['current_weather'];
      return '${current['temperature']}°C\n${current['windspeed']} km/h';
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> fetchTodayWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,windspeed_10m&current_weather=true&forecast_days=1');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final hourly = data['hourly'];

      final List<String> weatherToday =
          List.generate(hourly['time'].length, (index) {
        final rawTime = hourly['time'][index];
        final formattedTime = rawTime.substring(rawTime.indexOf('T') + 1);
        return '$formattedTime: ${hourly['temperature_2m'][index]}°C, ${hourly['windspeed_10m'][index]} km/h';
      });
      return weatherToday.join('\n');
    } else {
      throw Exception('Failed to load today\'s weather data');
    }
  }

  Future<String> fetchWeeklyWeather(double latitude, double longitude) async {
    final apiUrl = Uri.parse(
        '$weatherBaseUrl?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,windspeed_10m_max&current_weather=true&timezone=auto');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final daily = data['daily'];

      final List<String> weatherWeekly =
          List.generate(daily['time'].length, (index) {
        final rawTime = daily['time'][index];
        final formattedDay = rawTime.substring(rawTime.indexOf('-') + 1);
        return '$formattedDay: 최저 ${daily['temperature_2m_min'][index]}°C, 최고 ${daily['temperature_2m_max'][index]}°C, 최대 풍속 ${daily['windspeed_10m_max'][index]} km/h';
      });
      return weatherWeekly.join('\n');
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}
