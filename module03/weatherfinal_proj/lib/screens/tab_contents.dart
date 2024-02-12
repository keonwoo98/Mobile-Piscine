import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/widgets/current_weather_info.dart';
import 'package:weatherfinal_proj/widgets/today_weather_info.dart';
import 'package:weatherfinal_proj/widgets/weekly_weather_info.dart';

class TabContent extends StatelessWidget {
  final String title;
  const TabContent({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tabContent;
    final appState = context.watch<MyAppState>();
    const style = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    switch (title) {
      case 'Currently':
        tabContent = appState.currentWeather == null
            ? const Text('Currently', style: style)
            : const CurrentWeatherInfo();
        break;
      case 'Today':
        tabContent = tabContent = appState.todayWeather == null
            ? const Text('Today', style: style)
            : const TodayWeatherInfo();
        break;
      case 'Weekly':
        tabContent = tabContent = appState.weeklyWeather == null
            ? const Text('Weekly', style: style)
            : const WeeklyWeatherInfo();
        break;
      default:
        tabContent = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            tabContent,
          ],
        ),
      ),
    );
  }
}
