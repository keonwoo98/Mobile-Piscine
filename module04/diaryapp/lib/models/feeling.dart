import 'package:flutter/material.dart';

class Feeling {
  String iconName;
  Feeling({required this.iconName});

  IconData getIcon() {
    switch (iconName) {
      case "dissatisfied":
        return Icons.sentiment_dissatisfied_outlined;
      case "very_dissatisfied":
        return Icons.sentiment_very_dissatisfied_outlined;
      case "neutral":
        return Icons.sentiment_neutral_outlined;
      case "satisfied":
        return Icons.sentiment_satisfied_alt_outlined;
      case "very_satisfied":
        return Icons.sentiment_very_satisfied_outlined;
      default:
        return Icons.sentiment_neutral_outlined;
    }
  }

  Color getColor() {
    switch (iconName) {
      case "dissatisfied":
        return Colors.orange;
      case "very_dissatisfied":
        return Colors.red;
      case "neutral":
        return Colors.purple;
      case "satisfied":
        return Colors.green;
      case "very_satisfied":
        return Colors.blue;
      default:
        return Colors.yellow;
    }
  }
}
