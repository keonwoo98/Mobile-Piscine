import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherfinal_proj/providers/myappstate.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);

    String locationInfo = '';
    if (appState.region.isNotEmpty && appState.country.isNotEmpty) {
      locationInfo = '${appState.region}, ${appState.country}';
    } else if (appState.region.isNotEmpty && appState.region != appState.city) {
      locationInfo = appState.region;
    } else if (appState.country.isNotEmpty &&
        appState.country != appState.city) {
      locationInfo = appState.country;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(appState.city, style: titleStyle),
        if (locationInfo.isNotEmpty) Text(locationInfo, style: titleStyle),
      ],
    );
  }
}
