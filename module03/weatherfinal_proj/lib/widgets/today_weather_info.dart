import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/widgets/location_widget.dart';
import 'package:weatherfinal_proj/widgets/weather_icon_widget.dart';

class TodayWeatherInfo extends StatelessWidget {
  const TodayWeatherInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

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
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: -0.5,
      maxX: 24,
      minY: minY - 1.5,
      maxY: maxY + 1.5,
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
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );

    Widget hourlyListView() {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: appState.todayWeather!.time.length,
          itemBuilder: (context, index) {
            final dateTime = DateTime.parse(appState.todayWeather!.time[index]);
            final time = DateFormat('HH:mm').format(dateTime);
            final temperature =
                appState.todayWeather!.temperature2m[index]?.toStringAsFixed(1);
            final weatherCondition = appState.todayWeather!.weathercode[index];
            final windspeed =
                appState.todayWeather!.windspeed10m[index]?.toStringAsFixed(1);
            const style = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(time, style: style),
                  const SizedBox(height: 4),
                  WeatherIconWidget(weatherCode: weatherCondition),
                  const SizedBox(height: 4),
                  Text('$temperature°C', style: style),
                  const SizedBox(height: 4),
                  Text('$windspeed km/h', style: style),
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
        const LocationWidget(),
        const SizedBox(height: 14),
        const Text(
          'Today\'s Temperature',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 300,
          child: LineChart(data),
        ),
        const SizedBox(height: 14),
        hourlyListView(),
      ],
    );
  }
}
