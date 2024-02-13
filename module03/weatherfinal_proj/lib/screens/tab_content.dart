import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/models/weather_code_interpretation.dart';

class TabContent extends StatelessWidget {
  final String title;

  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
    final tempStyle =
        theme.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold);
    final descStyle =
        theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal);
    final windStyle =
        theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal);

    Widget locationWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(appState.city, style: titleStyle),
          Text('${appState.region}, ${appState.country}', style: titleStyle),
        ],
      );
    }

    Widget weatherIconWidget(int weatherCode) {
      IconData iconData;
      switch (weatherCode) {
        case 0: // Clear sky
          iconData = Icons.wb_sunny;
          break;
        case 1: // Mainly clear
        case 2: // Partly cloudy
          iconData = Icons.wb_cloudy;
          break;
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
          iconData = Icons.ac_unit;
          break;
        case 71: // Snow fall: Slight
        case 73: // Snow fall: Moderate
        case 75: // Snow fall: Heavy
          iconData = Icons.ac_unit;
          break;
        case 77: // Snow grains
          iconData = Icons.ac_unit;
          break;
        case 80: // Rain showers: Slight Intensity
        case 81: // Rain showers: Moderate
        case 82: // Rain showers: Violent
          iconData = Icons.shower;
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

      return Icon(iconData, size: 24, color: Colors.white);
    }

    Widget currentWeatherInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationWidget(),
          const SizedBox(height: 8),
          Text('${appState.currentWeather?.temperature}°C', style: tempStyle),
          const SizedBox(height: 8),
          Text(
              WeatherCodeInterpretation(
                      appState.currentWeather?.weathercode ?? 0)
                  .getter(),
              style: descStyle),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: weatherIconWidget(appState.currentWeather?.weathercode ?? 0),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.air, size: 24, color: Colors.blue),
              Text(' ${appState.currentWeather?.windspeed} km/h',
                  style: windStyle),
            ],
          ),
        ],
      );
    }

    Widget hourlyWeatherInfo() {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: appState.todayWeather?.time.length,
          itemBuilder: (context, index) {
            final dateTime = DateTime.parse(appState.todayWeather?.time[index]);
            final time = DateFormat('HH:mm').format(dateTime);
            final temperature =
                appState.todayWeather!.temperature2m[index]?.toStringAsFixed(1);
            final iconCode = appState.todayWeather!.weathercode[index];
            final windspeed =
                appState.todayWeather!.windspeed10m[index]?.toStringAsFixed(1);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(time, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  weatherIconWidget(iconCode),
                  const SizedBox(height: 4),
                  Text('$temperature°C', style: descStyle),
                  const SizedBox(height: 4),
                  Text('$windspeed km/h', style: theme.textTheme.bodySmall),
                ],
              ),
            );
          },
        ),
      );
    }

    Widget todayWeatherInfo() {
      List<FlSpot> spots = (appState.todayWeather != null)
          ? List.generate(appState.todayWeather!.time.length, (index) {
              String? timeString = appState.todayWeather!.time[index];
              String? temperatureString =
                  appState.todayWeather!.temperature2m[index]?.toString();

              double hour = timeString != null
                  ? double.tryParse(timeString.substring(11, 13)) ?? 0
                  : 0;
              double temp = temperatureString != null
                  ? double.tryParse(temperatureString) ?? 0
                  : 0;

              return FlSpot(hour, temp);
            })
          : [];

      Widget bottomTitleWidgets(double value, TitleMeta meta) {
        const style = TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );

        if (value % 1 > 0) {
          return Container();
        }

        final int index = value.toInt();
        if (index < 0 || index >= 24) {
          return Container();
        }

        Widget text = Text(
          DateFormat('HH:mm').format(DateTime(0, 0, 0, value.toInt())),
          style: style,
        );

        return Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: text,
        );
      }

      Widget leftTitleWidgets(double value, TitleMeta meta) {
        const style = TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );

        if (value % 2 == 0) {
          String text = '${value.toInt()}°C';
          return Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: FittedBox(
                  child: Text(text, style: style, textAlign: TextAlign.left)));
        } else {
          return Container();
        }
      }

      double minY = spots.map((e) => e.y).reduce(min);
      double maxY = spots.map((e) => e.y).reduce(max);

      minY = minY - 1.5;
      maxY = maxY + 1.5;

      LineChartData data = LineChartData(
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 2,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffe7e8ec), width: 1),
        ),
        minX: -0.5,
        maxX: 24,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orangeAccent,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.deepOrange,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0x33ffcc80),
            ),
          ),
        ],
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationWidget(),
          const SizedBox(height: 14),
          const Text(
            'Today Temperatures',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 300,
            child: LineChart(data),
          ),
          const SizedBox(height: 14),
          hourlyWeatherInfo(),
        ],
      );
    }

    Widget weeklyWeatherInfo() {
      List<FlSpot> minTempSpots = [];
      List<FlSpot> maxTempSpots = [];
      for (int i = 0; i < 7; i++) {
        minTempSpots.add(
            FlSpot(i.toDouble(), appState.weeklyWeather?.temperature2mMin[i]));
        maxTempSpots.add(
            FlSpot(i.toDouble(), appState.weeklyWeather?.temperature2mMax[i]));
      }
      double? minY = appState.weeklyWeather?.temperature2mMin
          .map((e) => e as double)
          .reduce(min);
      double? maxY = appState.weeklyWeather?.temperature2mMax
          .map((e) => e as double)
          .reduce(max);
      LineChartData chartData = LineChartData(
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 > 0) {
                  return Container();
                }
                final int index = value.toInt();
                if (index < 0 || index > 6) {
                  return Container();
                }

                final dateTime =
                    DateTime.parse(appState.weeklyWeather?.time[index]);
                final dayOfWeek = DateFormat('dd/MM').format(dateTime);

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4.0,
                  child: Text(dayOfWeek),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 2,
              getTitlesWidget: (value, meta) {
                if (value % 1 > 0) {
                  return Container();
                }
                return FittedBox(
                  child: Text('${value.toInt()}°C'),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: -0.3,
        maxX: 6.3,
        minY: minY != null ? minY - 1.5 : minY,
        maxY: maxY != null ? maxY + 1.5 : maxY,
        lineBarsData: [
          LineChartBarData(
            spots: minTempSpots,
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.blue,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                }),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: maxTempSpots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.red,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                }),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      );

      Widget legendWidget() {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Min temperature'),
            SizedBox(width: 20),
            Icon(Icons.timeline, color: Colors.red),
            SizedBox(width: 8),
            Text('Max temperature'),
          ],
        );
      }

      Widget weeklyListView() {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final dateTime =
                  DateTime.parse(appState.weeklyWeather?.time[index]);
              final weekday = DateFormat('dd/MM').format(dateTime);
              final minTemp = appState.weeklyWeather?.temperature2mMax[index];
              final maxTemp = appState.weeklyWeather?.temperature2mMin[index];
              final weatherCondition =
                  appState.weeklyWeather?.weathercode[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(weekday, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    weatherIconWidget(weatherCondition),
                    const SizedBox(height: 4),
                    Text('$maxTemp°C max'),
                    const SizedBox(height: 4),
                    Text('$minTemp°C min'),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationWidget(),
          const SizedBox(height: 14),
          const Text(
            'Weekly Temperatures',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 300,
            child: LineChart(chartData),
          ),
          legendWidget(),
          const SizedBox(height: 14),
          weeklyListView(),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (title == 'Currently')
              currentWeatherInfo()
            else if (title == 'Today')
              appState.todayWeather != null
                  ? todayWeatherInfo()
                  : const SizedBox.shrink()
            else if (title == 'Weekly')
              appState.todayWeather != null
                  ? weeklyWeatherInfo()
                  : const SizedBox.shrink()
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
