class WeatherInfo {
  final String location;
  final double temperature;
  final String description;
  final double windSpeed;

  WeatherInfo({
    required this.location,
    required this.temperature,
    required this.description,
    required this.windSpeed,
  });

  // API 응답으로부터 WeatherInfo 객체를 생성하는 팩토리 메서드 등 추가적인 메서드 구현 가능
}
