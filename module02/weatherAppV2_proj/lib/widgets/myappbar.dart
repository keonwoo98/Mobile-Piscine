import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_v2/providers/myappstate.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ThemeData theme;

  const MyAppBar({super.key, required this.theme});

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
                          appState.fetchWeatherForCity(suggestion);
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
    var appState = context.watch<MyAppState>();
    return AppBar(
      backgroundColor: widget.theme.colorScheme.primary,
      title: TextField(
        controller: textFieldController,
        cursorColor: widget.theme.colorScheme.onPrimary,
        style: TextStyle(color: widget.theme.colorScheme.onPrimary),
        onChanged: (text) {
          appState.fetchCitySuggestions(text);
          showOverlay(context);
        },
        onSubmitted: (text) async {
          await appState.fetchWeatherForCity(text);
          if (overlayEntry != null) {
            overlayEntry?.remove();
            overlayEntry = null;
          }
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: widget.theme.colorScheme.onPrimary),
          prefixIcon:
              Icon(Icons.search, color: widget.theme.colorScheme.onPrimary),
          suffixIcon: GestureDetector(
            onTap: () {
              textFieldController.clear();
              overlayEntry?.remove();
              overlayEntry = null;
            },
            child: Icon(Icons.clear, color: widget.theme.colorScheme.onPrimary),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            await appState.updateWeatherForCurrentLocation();
            textFieldController.clear();
          },
          child: Icon(
            Icons.gps_fixed_rounded,
            color: widget.theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
