import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app_v2/providers/myappstate.dart';
import 'package:weather_app_v2/widgets/myappbar.dart';
import 'package:weather_app_v2/widgets/mybottomappbar.dart';
import 'package:weather_app_v2/screens/tab_content.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'mobileModule02/weatherAppV2_proj',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: const Color(0xff1D71F2),
            secondary: const Color(0xffFFCD00),
            background: const Color(0xffE3F4FE),
          ),
          useMaterial3: true,
        ),
        home: const WeatherHomePage(),
      ),
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: MyAppBar(theme: Theme.of(context)),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            TabContent(title: 'Currently'),
            TabContent(title: 'Today'),
            TabContent(title: 'Weekly'),
          ],
        ),
        bottomNavigationBar: const MyBottomAppBar(),
      ),
    );
  }
}
