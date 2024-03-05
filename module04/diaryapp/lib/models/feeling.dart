import 'package:flutter/material.dart';

class Feeling {
  String iconName;
  Feeling({required this.iconName});

  IconData getIcon() {
    switch (iconName) {
      case 'dissatisfied':
        return Icons.sentiment_dissatisfied_outlined;
      case 'very_dissatisfied':
        return Icons.sentiment_very_dissatisfied_outlined;
      case 'neutral':
        return Icons.sentiment_neutral_outlined;
      case 'satisfied':
        return Icons.sentiment_satisfied_alt_outlined;
      case 'very_satisfied':
        return Icons.sentiment_very_satisfied_outlined;
      default:
        return Icons.sentiment_neutral_outlined;
    }
  }

  Color getColor() {
    switch (iconName) {
      case 'dissatisfied':
        return Colors.orange;
      case 'very_dissatisfied':
        return Colors.red;
      case 'neutral':
        return Colors.purple;
      case 'satisfied':
        return Colors.green;
      case 'very_satisfied':
        return Colors.blue;
      default:
        return Colors.yellow;
    }
  }

  static Feeling fromIconName(String iconName) {
    switch (iconName) {
      case 'dissatisfied':
        return Feeling(iconName: iconName); // 여기에 필요한 아이콘 등을 추가
      case 'very_dissatisfied':
        return Feeling(iconName: iconName);
      case 'neutral':
        return Feeling(iconName: iconName);
      case 'satisfied':
        return Feeling(iconName: iconName);
      case 'very_satisfied':
        return Feeling(iconName: iconName);
      default:
        return Feeling(iconName: 'neutral'); // 기본값 설정
    }
  }
}
