// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// class MyAppState extends ChangeNotifier {
//   // String location = '';
//   bool geolocationPermError = false;
//   List<String> citySuggestions = [];

//   MyPosition? myPosition;

//   Map<String, String> weatherData = {
//     'currently': "",
//     'today': "",
//     'weekly': "",
//   };

//   // 날씨 데이터를 저장하는 변수들
//   late String currentWeather = '';
//   late String todayWeather = '';
//   late String weeklyWeather = '';

//   // 날씨 API의 기본 URL
//   final String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
//   // Open-Meteo의 Geocoding API에 대한 기본 URL
//   final String geocodingBaseUrl =
//       'https://geocoding-api.open-meteo.com/v1/search';

//   // 도시 이름으로부터 좌표를 얻는 메소드
//   Future<void> fetchCitySuggestions(String query) async {
//     if (query.isEmpty) {
//       citySuggestions = [];
//       notifyListeners();
//       return;
//     }

//     // Open-Meteo Geocoding API를 호출합니다.
//     final response = await http.get(Uri.parse('$geocodingBaseUrl?name=$query'));
//     if (response.statusCode == 200) {
//       // 응답으로부터 도시 목록을 파싱합니다.
//       final data = json.decode(response.body);
//       if (data['results'] != null) {
//         citySuggestions = List<String>.from(
//           data['results'].map((result) =>
//               "${result['name']}, ${result['admin1']}, ${result['country']}"),
//         );
//       } else {
//         citySuggestions = [];
//       }
//     } else {
//       citySuggestions = [];
//       // 오류 처리를 위한 로직을 추가할 수 있습니다.
//     }
//     notifyListeners();
//   }

//   // 선택된 도시의 날씨 정보를 가져오는 메소드
//   Future<void> fetchWeatherForCity(String searchText) async {
//     List<String> parts = searchText.split(RegExp(r'\s+'));

//     String city = parts[0];
//     String region = parts.length == 3 ? parts[1] : '';
//     String country = parts[parts.length - 1];
//     var response = await http.get(Uri.parse('$geocodingBaseUrl?name=$city'));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       if (data['results'] != null && data['results'].isNotEmpty) {
//         var result = data['results'][0];
//         setLocation(result['latitude'], result['longitude']);
//         fetchCurrentWeather();
//         fetchTodayWeather();
//         fetchWeeklyWeather();
//       } else {
//         // location = '$city 도시 정보를 찾을 수 없습니다.';
//       }
//     } else {
//       // location = '도시 정보를 가져오는데 실패했습니다.';
//     }
//     notifyListeners();
//   }

//   Future<void> fetchCurrentWeather() async {
//     final apiUrl = Uri.parse(
//         '$weatherBaseUrl?latitude=${myPosition?.latitude}&longitude=${myPosition?.longitude}&current_weather=true');
//     final response = await http.get(apiUrl);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final current = data['current_weather'];
//       currentWeather =
//           '${current['temperature']}°C\n${current['windspeed']} km/h';
//     } else {
//       // 오류 처리...
//     }
//     notifyListeners();
//   }

//   // 오늘의 날씨 데이터를 가져오는 메서드
//   Future<void> fetchTodayWeather() async {
//     final apiUrl = Uri.parse(
//         '$weatherBaseUrl?latitude=${myPosition?.latitude}&longitude=${myPosition?.longitude}&hourly=temperature_2m,windspeed_10m&current_weather=true&forecast_days=1');
//     final response = await http.get(apiUrl);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final hourly = data['hourly'];

//       final List<String> weatherToday =
//           List.generate(hourly['time'].length, (index) {
//         final rawTime = hourly['time'][index];
//         final formattedTime = rawTime.substring(rawTime.indexOf('T') + 1);
//         return '$formattedTime\t\t\t\t\t\t\t\t${hourly['temperature_2m'][index]}°C\t\t\t\t\t\t\t\t${hourly['windspeed_10m'][index]}km/h';
//       });
//       todayWeather = weatherToday.join('\n');
//     } else {
//       // 오류 처리...
//     }
//     notifyListeners();
//   }

//   // 주간 날씨 데이터를 가져오는 메서드
//   Future<void> fetchWeeklyWeather() async {
//     final apiUrl = Uri.parse(
//         '$weatherBaseUrl?latitude=${myPosition?.latitude}&longitude=${myPosition?.longitude}&hourly=temperature_2m&daily=weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max&current_weather=true&timezone=auto');
//     final response = await http.get(apiUrl);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final daily = data['daily'];
//       final List<String> weatherToday =
//           List.generate(daily['time'].length, (index) {
//         final rawTime = daily['time'][index];
//         final formattedDay = rawTime.substring(rawTime.indexOf('-') + 1);
//         final String weatherDescription =
//             WeatherCodeInterpretation(daily['weathercode'][index]).getter();
//         return '$formattedDay\t\t\t\t\t\t\t${daily['temperature_2m_min'][index]}°C\t\t\t\t\t\t\t${daily['temperature_2m_max'][index]}°C\t\t\t\t\t\t$weatherDescription';
//       });
//       weeklyWeather = weatherToday.join('\n');
//     } else {
//       // 오류 처리...
//     }
//     notifyListeners();
//   }

//   void setLocation(double latitude, double longtitude) {
//     myPosition = MyPosition(latitude: latitude, longitude: longtitude);
//     geolocationPermError = false;
//     notifyListeners();
//   }

//   void setGeolocationPermError(bool value) {
//     geolocationPermError = value;
//     notifyListeners();
//   }

//   Future<int> getGeoPermission() async {
//     bool geoEnabled = false;
//     geoEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!geoEnabled) {
//       setGeolocationPermError(true);
//       return -1;
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setGeolocationPermError(true);
//         return -1;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       setGeolocationPermError(true);
//       return -1;
//     }
//     return 0;
//   }

//   void getGeolocation() async {
//     if (await getGeoPermission() == -1) return;
//     Position geolocation = await Geolocator.getCurrentPosition();
//     setLocation(geolocation.latitude, geolocation.longitude);
//   }
// }

// class WeatherData {
//   double temperature;
//   String weatherDescription;
//   double windSpeed;

//   WeatherData(this.temperature, this.weatherDescription, this.windSpeed);

//   factory WeatherData.fromJson(Map<String, dynamic> json) {
//     return WeatherData(
//       json['temperature'],
//       parseWeatherCode(json['weathercode']),
//       json['windspeed'],
//     );
//   }

//   // 날씨 코드를 문자열 설명으로 변환
//   static String parseWeatherCode(int code) {
//     switch (code) {
//       // 예시: code 0은 "맑음"을 의미
//       case 0:
//         return "맑음";
//       // ... 다른 날씨 코드에 대한 처리 ...
//       default:
//         return "알 수 없음";
//     }
//   }
// }

// // class CurrentTab extends StatelessWidget {
// //   const CurrentTab({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     var appState = context.watch<MyAppState>();
// //     return Center(
// //       child: Column(
// //         children: [
// //           Text('위치: ${appState.location}'),
// //           Text('온도: ${appState.currentWeather.temperature}°C'),
// //           Text('날씨: ${appState.currentWeather.weatherDescription}'),
// //           Text('풍속: ${appState.currentWeather.windSpeed}km/h'),
// //         ],
// //       ),
// //     );
// //   }
// // }

// class MyPosition {
//   double latitude;
//   double longitude;

//   MyPosition({required this.latitude, required this.longitude});
// }

// class LastSearchText {
//   final Map<String, String> lastSearchText = {
//     'currently': '',
//     'today': '',
//     'weekly': '',
//   };

//   LastSearchText(String suggestion) {
//     lastSearchText['currently'] = suggestion;
//     lastSearchText['today'] = suggestion;
//     lastSearchText['weekly'] = suggestion;
//   }
//   Map<String, String> get updatedSearchText => lastSearchText;
// }

import 'package:flutter/material.dart';
import 'package:weather_app_v2/services/geolocation_service.dart';
import 'package:weather_app_v2/services/weather_service.dart';

class MyAppState extends ChangeNotifier {
  final GeolocationService _geolocationService = GeolocationService();
  final WeatherService _weatherService = WeatherService();

  bool geolocationPermError = false;
  String currentWeather = '';
  String todayWeather = '';
  String weeklyWeather = '';
  List<String> citySuggestions = [];
  String city = '';
  String region = '';
  String country = '';
  String error = '';
  // final Map<String, String> lastSearchText = {
  //   'city': '',
  //   'region': '',
  //   'country': '',
  // };

  // void setLastSearchText(String city, String region, String country) {
  //   lastSearchText['city'] = city;
  //   lastSearchText['region'] = region;
  //   lastSearchText['country'] = country;
  //   notifyListeners();
  // }

  Future<void> updateWeatherForCurrentLocation() async {
    geolocationPermError = false;
    try {
      final position = await _geolocationService.getGeolocation();
      await _fetchWeatherData(position.latitude, position.longitude);
      city = '';
      region = '';
      country = '';
      notifyListeners();
    } catch (e) {
      geolocationPermError = true;
      error =
          'Geolocation is not available, please enable it in your App settings';
      notifyListeners();
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    geolocationPermError = false;
    try {
      currentWeather =
          await _weatherService.fetchCurrentWeather(latitude, longitude);
      todayWeather =
          await _weatherService.fetchTodayWeather(latitude, longitude);
      weeklyWeather =
          await _weatherService.fetchWeeklyWeather(latitude, longitude);
      notifyListeners();
    } catch (e) {
      geolocationPermError = true;
      error =
          'The service connection is lost. Please check your internet connection or try again later.';
      notifyListeners();
    }
  }

  Future<void> fetchWeatherForCity(String searchText) async {
    // List<String> parts = searchText.split(RegExp(', '));

    // city = parts[0];
    // region = parts.length == 3 ? parts[1] : '';
    // country = parts[parts.length - 1];
    city = '';
    region = '';
    country = '';
    geolocationPermError = false;
    try {
      final data = await _weatherService
          .fetchWeatherForCity(searchText.split(',')[0].trim());
      if (data['results'] != null && data['results'].isNotEmpty) {
        var result = data['results'][0];
        await _fetchWeatherData(result['latitude'], result['longitude']);
        city = result['name'];
        region = result['admin1'];
        country = result['country'];
        notifyListeners();
      } else {
        geolocationPermError = true;
        error =
            'Could not find any result for the supplied address or coordinates.';
        notifyListeners();
      }
    } catch (e) {
      geolocationPermError = true;
      error =
          'The service connection is lost. Please check your internet connection or try again later.';
      notifyListeners();
    }
  }

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      citySuggestions = [];
      notifyListeners();
      return;
    }
    // WeatherService의 도시 제안 가져오기 메서드 호출 예시
    citySuggestions = await _weatherService.fetchCitySuggestions(query);
    notifyListeners();
  }

  Future<void> getGeolocation() async {
    geolocationPermError = false;
    try {
      final position = await _geolocationService.getGeolocation();
      // 성공적으로 위치 정보를 가져온 후, 해당 위치에 대한 날씨 정보를 업데이트
      await _fetchWeatherData(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      // 오류 처리: 예를 들어, 사용자에게 위치 정보 접근 권한 요청 실패 알림
      geolocationPermError = true;
      error = '접근 권한 요청 실패';
      notifyListeners();
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
