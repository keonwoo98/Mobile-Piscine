import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final int weatherCode;
  const WeatherIconWidget({Key? key, required this.weatherCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (weatherCode) {
      case 0: // Clear sky
      case 1: // Mainly clear
        iconData = Icons.sunny;
        break;
      case 2: // Partly cloudy
      case 3: // Overcast
        iconData = Icons.cloud;
        break;
      case 45: // Fog
      case 48: // Depositing rime fog
        iconData = Icons.foggy;
        break;
      case 51: // Drizzle: Light Intensity
      case 53: // Drizzle: Moderate Intensity
      case 55: // Drizzle: Intense
        iconData = Icons.grain;
        break;
      case 61: // Rain: Slight intensity
      case 63: // Rain: Moderate
      case 65: // Rain: Heavy
        iconData = Icons.umbrella;
        break;
      case 66: // Freezing Rain: Light Intensity
      case 67: // Freezing Rain: Heavy
      case 71: // Snow fall: Slight
      case 73: // Snow fall: Moderate
      case 75: // Snow fall: Heavy
      case 77: // Snow grains
        iconData = Icons.ac_unit;
        break;
      case 80: // Rain showers: Slight Intensity
      case 81: // Rain showers: Moderate
      case 82: // Rain showers: Violent
        iconData = Icons.umbrella;
        break;
      case 85: // Snow showers: slight
      case 86: // Snow showers: heavy
        iconData = Icons.ac_unit;
        break;
      case 95: // Thunderstorm: Slight or Moderate
      case 96: // Thunderstorm with slight hail
      case 99: // Thunderstorm with heavy hail
        iconData = Icons.flash_on;
        break;
      default:
        iconData = Icons.error;
    }

    return Icon(iconData, size: 42);
  }
}
