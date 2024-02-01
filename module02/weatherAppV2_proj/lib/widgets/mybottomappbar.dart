import 'package:flutter/material.dart';

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
