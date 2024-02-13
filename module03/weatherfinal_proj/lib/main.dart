import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weatherfinal_proj/providers/myappstate.dart';
import 'package:weatherfinal_proj/widgets/myappbar.dart';
import 'package:weatherfinal_proj/widgets/mybottomappbar.dart';
import 'package:weatherfinal_proj/screens/tab_contents.dart';

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
        extendBody: true,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  TabContent(title: 'Currently'),
                  TabContent(title: 'Today'),
                  TabContent(title: 'Weekly'),
                ],
              ),
            ),
            Positioned(
              top: -5,
              left: 10,
              right: 10,
              child: MyAppBar(theme: Theme.of(context)),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomAppBar(theme: Theme.of(context)),
      ),
    );
  }
}
