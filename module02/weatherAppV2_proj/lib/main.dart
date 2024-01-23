import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
    var appState = context.watch<MyAppState>();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: MyAppBar(theme: Theme.of(context), appState: appState),
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

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;
  final MyAppState appState;

  const MyAppBar({super.key, required this.theme, required this.appState});

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      title: TextField(
        controller: textFieldController,
        cursorColor: theme.colorScheme.onPrimary,
        style: TextStyle(color: theme.colorScheme.onPrimary),
        onSubmitted: (text) => appState.setLocation(textFieldController.text),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: theme.colorScheme.onPrimary),
          prefixIcon: GestureDetector(
            onTap: () => appState.setLocation(textFieldController.text),
            child: Icon(
              Icons.search,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () async => appState.getGeolocation(),
            child: Icon(
              Icons.gps_fixed_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      clipBehavior: Clip.none,
      child: TabBar(
        indicator: null,
        tabs: [
          Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Currently'),
          Tab(icon: Icon(Icons.today_outlined), text: 'Today'),
          Tab(icon: Icon(Icons.calendar_today_outlined), text: 'Weekly'),
        ],
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final String title;
  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final locationStyle = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final titleStyle =
        theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);
    final errorStyle = titleStyle.copyWith(color: theme.colorScheme.error);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: !appState.geolocationPermError
          ? [
              Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              Text(
                appState.location,
                style: locationStyle,
                textAlign: TextAlign.center,
              ),
            ]
          : [
              Text(
                'Geolocation is not available, please enable it in you App settings',
                style: errorStyle,
                textAlign: TextAlign.center,
              )
            ],
    ));
  }
}

class MyAppState extends ChangeNotifier {
  String location = '';
  bool geolocationPermError = false;

  void setLocation(String input) {
    location = input;
    geolocationPermError = false;
    notifyListeners();
  }

  void setGeolocationPermError(bool value) {
    geolocationPermError = value;
    notifyListeners();
  }

  Future<int> getGeoPermission() async {
    bool geoEnabled = false;
    geoEnabled = await Geolocator.isLocationServiceEnabled();
    if (!geoEnabled) {
      setGeolocationPermError(true);
      return -1;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setGeolocationPermError(true);
        return -1;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setGeolocationPermError(true);
      return -1;
    }
    return 0;
  }

  void getGeolocation() async {
    if (await getGeoPermission() == -1) return;
    Position geolocation = await Geolocator.getCurrentPosition();
    setLocation(geolocation.toString());
  }
}
