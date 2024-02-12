import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/models/weather_code_interpretation.dart';
import 'package:weatherfinal_proj/widgets/location_widget.dart';
import 'package:weatherfinal_proj/widgets/weather_icon_widget.dart';

class CurrentWeatherInfo extends StatelessWidget {
  const CurrentWeatherInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final tempStyle =
        theme.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold);
    final descStyle =
        theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
    final windStyle =
        theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const LocationWidget(),
        const SizedBox(height: 24),
        Text('${appState.currentWeather?.temperature}°C', style: tempStyle),
        const SizedBox(height: 8),
        Text(
            WeatherCodeInterpretation(appState.currentWeather?.weathercode ?? 0)
                .getter(),
            style: descStyle),
        const SizedBox(height: 8),
        WeatherIconWidget(
            weatherCode: appState.currentWeather?.weathercode ?? 0),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.air, size: 32),
            Text(' ${appState.currentWeather?.windspeed} km/h',
                style: windStyle),
          ],
        ),
      ],
    );
  }
}
