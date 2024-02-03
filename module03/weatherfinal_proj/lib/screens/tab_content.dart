import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';

class TabContent extends StatelessWidget {
  final String title;

  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);
    final textStyle =
        theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal);
    final errorStyle = titleStyle.copyWith(color: theme.colorScheme.error);

    Widget locationWidget() {
      return Column(
        children: [
          Text(appState.city, style: titleStyle),
          Text(appState.region, style: titleStyle),
          Text(appState.country, style: titleStyle),
        ],
      );
    }

    Widget weatherInfoWidget(String weatherData) {
      return Column(
        children: [
          locationWidget(),
          Text(weatherData, style: textStyle),
        ],
      );
    }

    Map<String, Widget Function()> contentMap = {
      'Currently': () => weatherInfoWidget(appState.currentWeather),
      'Today': () => weatherInfoWidget(appState.todayWeather),
      'Weekly': () => weatherInfoWidget(appState.weeklyWeather),
    };

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: !appState.geolocationPermError
              ? [
                  contentMap[title]?.call() ??
                      Text('Unknown tab', style: textStyle)
                ]
              : [Text(appState.error, style: errorStyle)],
        ),
      ),
    );
  }
}
