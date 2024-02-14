import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/widgets/location_widget.dart';
import 'package:weatherfinal_proj/widgets/weather_icon_widget.dart';

class WeeklyWeatherInfo extends StatelessWidget {
  const WeeklyWeatherInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    List<FlSpot> minTempSpots = [];
    List<FlSpot> maxTempSpots = [];
    for (int i = 0; i < appState.weeklyWeather!.time.length; i++) {
      minTempSpots.add(
          FlSpot(i.toDouble(), appState.weeklyWeather?.temperature2mMin[i]));
      maxTempSpots.add(
          FlSpot(i.toDouble(), appState.weeklyWeather?.temperature2mMax[i]));
    }

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
      if (index < 0 || index > 6) {
        return Container();
      }

      final dateTime = DateTime.parse(appState.weeklyWeather?.time[index]);
      final dayOfWeek = DateFormat('dd/MM').format(dateTime);

      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(dayOfWeek, style: style),
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
      if (value % 1 > 0) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: FittedBox(
          child: Text('${value.toInt()}°C', style: style),
        ),
      );
    }

    double minY = minTempSpots.map((e) => e.y).reduce(min);
    double maxY = maxTempSpots.map((e) => e.y).reduce(max);

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
      minX: -0.3,
      maxX: 6.3,
      minY: minY - 1.5,
      maxY: maxY + 1.5,
      lineBarsData: [
        LineChartBarData(
          spots: minTempSpots,
          isCurved: true,
          color: Colors.blueAccent,
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
          barWidth: 3,
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
            final maxTemp = appState.weeklyWeather?.temperature2mMax[index];
            final minTemp = appState.weeklyWeather?.temperature2mMin[index];
            final weatherCondition = appState.weeklyWeather?.weathercode[index];
            const style = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(weekday, style: style),
                  const SizedBox(height: 4),
                  WeatherIconWidget(weatherCode: weatherCondition),
                  const SizedBox(height: 4),
                  Text('$minTemp°C min', style: style),
                  const SizedBox(height: 4),
                  Text('$maxTemp°C max', style: style),
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
        const LocationWidget(),
        const SizedBox(height: 14),
        const Text(
          'Weekly Temperature',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 300,
          child: LineChart(chartData),
        ),
        const SizedBox(height: 10),
        legendWidget(),
        const SizedBox(height: 18),
        weeklyListView(),
      ],
    );
  }
}
