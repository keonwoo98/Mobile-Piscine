import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  late String id;
  late String icon;
  late String text = '';
  late String title;
  late DateTime date;
  late String userMail;

  Entry({
    required this.date,
    required this.title,
    required this.userMail,
    required this.id,
    required this.icon,
    required this.text,
  });

  Entry.fromSnapshot(DocumentSnapshot snapshot) {
    icon = snapshot.get('icon') ?? '';
    text = snapshot.get('text') ?? '';
    title = snapshot.get('title') ?? '';
    date = snapshot.get('date').toDate() ?? '';
    userMail = snapshot.get('userMail') ?? '';
    id = snapshot.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'text': text,
      'title': title,
      'date': date,
      'userMail': userMail,
    };
  }
}
