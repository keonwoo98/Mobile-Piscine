import 'package:flutter/material.dart';

class MyBottomAppBar extends StatelessWidget {
  final ThemeData theme;
  const MyBottomAppBar({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: theme.colorScheme.background.withOpacity(0.6),
      clipBehavior: Clip.none,
      child: const TabBar(
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
