import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diaryapp/models/feeling.dart';

class FeelingRatiosResult {
  final Map<String, double> ratios;
  final int totalEntries;

  FeelingRatiosResult(this.ratios, this.totalEntries);
}

class FeelingRatios extends StatelessWidget {
  final String? userEmail;

  const FeelingRatios({Key? key, this.userEmail}) : super(key: key);

  Map<String, double> initializeFeelingRatios() {
    return {
      'dissatisfied': 0.0,
      'very_dissatisfied': 0.0,
      'neutral': 0.0,
      'satisfied': 0.0,
      'very_satisfied': 0.0,
    };
  }

  Stream<FeelingRatiosResult> fetchFeelingRatiosStream() {
    return FirebaseFirestore.instance
        .collection('diary_entries')
        .where('userMail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) {
      Map<String, double> feelingRatios = initializeFeelingRatios();
      int totalEntries = snapshot.docs.length;

      if (totalEntries > 0) {
        Map<String, int> feelingCounts = {};
        for (var doc in snapshot.docs) {
          String feeling = doc.data()['icon'] ?? 'neutral';
          feelingCounts[feeling] = (feelingCounts[feeling] ?? 0) + 1;
        }

        feelingCounts.forEach((feeling, cntValue) {
          feelingRatios[feeling] = cntValue / totalEntries.toDouble();
        });
      }

      return FeelingRatiosResult(feelingRatios, totalEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FeelingRatiosResult>(
      stream: fetchFeelingRatiosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final int totalEntries = data.totalEntries;
          final Map<String, double> ratios = data.ratios;

          return Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Total Entries: $totalEntries',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...ratios.entries.map((entry) {
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
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
