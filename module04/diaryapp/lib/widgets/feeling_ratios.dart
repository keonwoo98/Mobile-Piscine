import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diaryapp/models/feeling.dart';

class FeelingRatios extends StatelessWidget {
  final String? userEmail;

  FeelingRatios({Key? key, this.userEmail}) : super(key: key);

  Stream<Map<String, double>> fetchFeelingRatiosStream() {
    return FirebaseFirestore.instance
        .collection('diary_entries')
        .where('userMail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) {
      Map<String, int> feelingCounts = {};
      for (var doc in snapshot.docs) {
        String feeling = doc['icon'];
        feelingCounts[feeling] = (feelingCounts[feeling] ?? 0) + 1;
      }
      final totalEntries = snapshot.docs.length;
      return feelingCounts.map((feeling, countValue) =>
          MapEntry(feeling, countValue / totalEntries.toDouble()));
    });
  }

  final List<String> _feelingOrder = [
    'very_dissatisfied',
    'dissatisfied',
    'neutral',
    'satisfied',
    'very_satisfied',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: fetchFeelingRatiosStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        Map<String, double> sortedFeelings = Map.fromEntries(
          _feelingOrder
              .map((key) => MapEntry(key, snapshot.data![key] ?? 0))
              .where((entry) => entry.value > 0),
        );
        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: sortedFeelings.entries.map((entry) {
                String feelingName =
                    entry.key.replaceAll('_', ' ').capitalize();
                return ListTile(
                  leading: Icon(
                    Feeling.getIcon(entry.key),
                    color: Feeling.getColor(entry.key),
                  ),
                  title: Text(
                      '$feelingName: ${(entry.value * 100).toStringAsFixed(1)}%'),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
