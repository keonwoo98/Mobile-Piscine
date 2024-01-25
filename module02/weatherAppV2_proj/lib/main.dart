// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'mobileModule02/weatherAppV2_proj',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const WeatherHomePage(),
//       ),
//     );
//   }
// }

// class WeatherHomePage extends StatelessWidget {
//   const WeatherHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return DefaultTabController(
//       length: 3,
//       initialIndex: 0,
//       child: Scaffold(
//         appBar: MyAppBar(theme: Theme.of(context), appState: appState),
//         body: const TabBarView(
//           physics: BouncingScrollPhysics(),
//           children: [
//             TabContent(title: 'Currently'),
//             TabContent(title: 'Today'),
//             TabContent(title: 'Weekly'),
//           ],
//         ),
//         bottomNavigationBar: const MyBottomAppBar(),
//       ),
//     );
//   }
// }

// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final ThemeData theme;
//   final MyAppState appState;

//   const MyAppBar({super.key, required this.theme, required this.appState});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController textFieldController = TextEditingController();

//     return AppBar(
//       backgroundColor: theme.colorScheme.primary,
//       title: TextField(
//         controller: textFieldController,
//         cursorColor: theme.colorScheme.onPrimary,
//         style: TextStyle(color: theme.colorScheme.onPrimary),
//         onSubmitted: (text) => appState.setLocation(textFieldController.text),
//         decoration: InputDecoration(
//           hintText: 'Search',
//           hintStyle: TextStyle(color: theme.colorScheme.onPrimary),
//           prefixIcon: GestureDetector(
//             onTap: () => appState.setLocation(textFieldController.text),
//             child: Icon(
//               Icons.search,
//               color: theme.colorScheme.onPrimary,
//             ),
//           ),
//           suffixIcon: GestureDetector(
//             onTap: () async => appState.getGeolocation(),
//             child: Icon(
//               Icons.gps_fixed_rounded,
//               color: theme.colorScheme.onPrimary,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => AppBar().preferredSize;
// }

// class MyBottomAppBar extends StatelessWidget {
//   const MyBottomAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BottomAppBar(
//       clipBehavior: Clip.none,
//       child: TabBar(
//         indicator: null,
//         tabs: [
//           Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Currently'),
//           Tab(icon: Icon(Icons.today_outlined), text: 'Today'),
//           Tab(icon: Icon(Icons.calendar_today_outlined), text: 'Weekly'),
//         ],
//       ),
//     );
//   }
// }

// class TabContent extends StatelessWidget {
//   final String title;
//   const TabContent({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     final theme = Theme.of(context);
//     final locationStyle = theme.textTheme.headlineMedium!.copyWith(
//       color: theme.colorScheme.primary,
//       fontWeight: FontWeight.bold,
//     );
//     final titleStyle =
//         theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);
//     final errorStyle = titleStyle.copyWith(color: theme.colorScheme.error);
//     return Center(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: !appState.geolocationPermError
//           ? [
//               Text(
//                 title,
//                 style: titleStyle,
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 appState.location,
//                 style: locationStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ]
//           : [
//               Text(
//                 'Geolocation is not available, please enable it in you App settings',
//                 style: errorStyle,
//                 textAlign: TextAlign.center,
//               )
//             ],
//     ));
//   }
// }

// class MyAppState extends ChangeNotifier {
//   String location = '';
//   bool geolocationPermError = false;

//   void setLocation(String input) {
//     location = input;
//     geolocationPermError = false;
//     notifyListeners();
//   }

//   void setGeolocationPermError(bool value) {
//     geolocationPermError = value;
//     notifyListeners();
//   }

//   Future<int> getGeoPermission() async {
//     bool geoEnabled = false;
//     geoEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!geoEnabled) {
//       setGeolocationPermError(true);
//       return -1;
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setGeolocationPermError(true);
//         return -1;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       setGeolocationPermError(true);
//       return -1;
//     }
//     return 0;
//   }

//   void getGeolocation() async {
//     if (await getGeoPermission() == -1) return;
//     Position geolocation = await Geolocator.getCurrentPosition();
//     setLocation(geolocation.toString());
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ThemeData theme;
  final MyAppState appState;

  const MyAppBar({super.key, required this.theme, required this.appState});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  late TextEditingController textFieldController;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    textFieldController = TextEditingController();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay(BuildContext context) {
    overlayEntry?.remove();
    overlayEntry = createOverlayEntry(context);
    Overlay.of(context).insert(overlayEntry!);
  }

  OverlayEntry createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: Consumer<MyAppState>(
            builder: (_, appState, __) => ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: appState.citySuggestions
                  .map((suggestion) => ListTile(
                        title: Text(suggestion),
                        onTap: () {
                          textFieldController.text = suggestion;
                          // appState.fetchWeatherForCity(suggestion);
                          String cityName = suggestion.split(',')[0].trim();
                          appState.fetchWeatherForCity(cityName);
                          overlayEntry?.remove();
                          overlayEntry = null;
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.theme.colorScheme.primary,
      title: TextField(
        controller: textFieldController,
        cursorColor: widget.theme.colorScheme.onPrimary,
        style: TextStyle(color: widget.theme.colorScheme.onPrimary),
        onChanged: (text) {
          widget.appState.fetchCitySuggestions(text);
          showOverlay(context);
        },
        onSubmitted: (text) {
          widget.appState.fetchWeatherForCity(text);
          if (overlayEntry != null) {
            overlayEntry?.remove();
            overlayEntry = null;
          }
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: widget.theme.colorScheme.onPrimary),
          prefixIcon: Icon(
            Icons.search,
            color: widget.theme.colorScheme.onPrimary,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              textFieldController.clear();
              overlayEntry?.remove();
              overlayEntry = null;
            },
            child: Icon(
              Icons.clear,
              color: widget.theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async => widget.appState.getGeolocation(),
          child: Icon(
            Icons.gps_fixed_rounded,
            color: widget.theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
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
  List<String> citySuggestions = [];

  // Open-Meteo의 Geocoding API에 대한 기본 URL
  final String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  // 도시 이름으로부터 좌표를 얻는 메소드
  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      citySuggestions = [];
      notifyListeners();
      return;
    }

    // Open-Meteo Geocoding API를 호출합니다.
    var response = await http.get(Uri.parse('$geocodingBaseUrl?name=$query'));
    if (response.statusCode == 200) {
      // 응답으로부터 도시 목록을 파싱합니다.
      var data = json.decode(response.body);
      if (data['results'] != null) {
        citySuggestions = List<String>.from(
          data['results'].map((result) =>
              "${result['name']}, ${result['admin1']}, ${result['country']}"),
        );
      } else {
        citySuggestions = [];
      }
    } else {
      citySuggestions = [];
      // 오류 처리를 위한 로직을 추가할 수 있습니다.
    }
    notifyListeners();
  }

  // 선택된 도시의 날씨 정보를 가져오는 메소드
  Future<void> fetchWeatherForCity(String city) async {
    // Open-Meteo Geocoding API를 호출하여 좌표를 얻습니다.
    var response = await http.get(Uri.parse('$geocodingBaseUrl?name=$city'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        var result = data['results'][0];
        var latitude = result['latitude'];
        var longitude = result['longitude'];

        // 여기에 날씨 정보를 가져오는 로직을 구현하세요.
        // 예: Open-Meteo의 Weather API를 호출합니다.
        location = '$city: $result'; // 날씨 API 호출 결과에 따라 업데이트해야 합니다.
      } else {
        location = '$city 도시 정보를 찾을 수 없습니다.';
      }
    } else {
      location = '도시 정보를 가져오는데 실패했습니다.';
      // 오류 처리를 위한 로직을 추가할 수 있습니다.
    }
    notifyListeners();
  }

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
