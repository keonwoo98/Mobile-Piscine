import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mobileModule01/weatherApp_proj',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController searchController;
  int selectedIndex = 0;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            onSubmitted: (text) => setState(() {
              searchText = text;
            }),
            decoration: const InputDecoration(
              hintText: 'Search',
              icon: Icon(Icons.search),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => setState(() {
                if (searchText.contains('Geolocation')) {
                  searchText = '';
                } else {
                  searchController.text = '';
                  searchText = 'Geolocation';
                }
              }),
              icon: !searchText.contains('Geolocation')
                  ? const Icon(Icons.location_off_outlined)
                  : const Icon(Icons.location_on_sharp),
            ),
          ],
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          controller: tabController,
          children: [
            TabContent(title: 'Currently Tab Content\n$searchText'),
            TabContent(title: 'Today Tab Content\n$searchText'),
            TabContent(title: 'Weekly Tab Content\n$searchText'),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.none,
          child: TabBar(
            controller: tabController,
            indicator: null,
            tabs: const [
              Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Currently'),
              Tab(icon: Icon(Icons.today_outlined), text: 'Today'),
              Tab(icon: Icon(Icons.calendar_today_outlined), text: 'Weekly'),
            ],
          ),
        ),
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final String title;
  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
