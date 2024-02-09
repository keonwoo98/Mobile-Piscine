class CurrentWeather {
  final double temperature;
  final double windspeed;
  final int weathercode;

  CurrentWeather({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature'],
      windspeed: json['windspeed'],
      weathercode: json['weathercode'],
    );
  }
}

class TodayWeather {
  final List<dynamic> time;
  final List<dynamic> weathercode;
  final List<dynamic> temperature2m;
  final List<dynamic> windspeed10m;

  TodayWeather({
    required this.time,
    required this.weathercode,
    required this.temperature2m,
    required this.windspeed10m,
  });

  factory TodayWeather.fromJson(Map<String, dynamic> json) {
    return TodayWeather(
      time: json['time'],
      weathercode: json['weathercode'],
      temperature2m: json['temperature_2m'],
      windspeed10m: json['windspeed_10m'],
    );
  }
}

class WeekWeather {
  final List<dynamic> time;
  final List<dynamic> weathercode;
  final List<dynamic> temperature2mMax;
  final List<dynamic> temperature2mMin;
  final List<dynamic> windspeed10mMax;

  WeekWeather({
    required this.time,
    required this.weathercode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.windspeed10mMax,
  });

  factory WeekWeather.fromJson(Map<String, dynamic> json) {
    return WeekWeather(
      time: json['time'],
      weathercode: json['weathercode'],
      temperature2mMax: json['temperature_2m_max'],
      temperature2mMin: json['temperature_2m_min'],
      windspeed10mMax: json['windspeed_10m_max'],
    );
  }
}
