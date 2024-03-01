import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/models/feeling.dart';

class EntryCreationPage extends StatefulWidget {
  const EntryCreationPage({Key? key}) : super(key: key);

  @override
  State<EntryCreationPage> createState() => _EntryCreationPageState();
}

class _EntryCreationPageState extends State<EntryCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _text = '';
  final DateTime _date = DateTime.now();
  String _selectedFeeling = "neutral";
  final List<Feeling> _feelings = [
    Feeling(iconName: "dissatisfied"),
    Feeling(iconName: "very_dissatisfied"),
    Feeling(iconName: "neutral"),
    Feeling(iconName: "satisfied"),
    Feeling(iconName: "very_satisfied"),
  ];

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final entry = Entry(
        date: _date,
        title: _title,
        text: _text,
        userMail: FirebaseAuth.instance.currentUser!.email!,
        id: '',
        icon: _selectedFeeling,
        feeling: _feelings
            .firstWhere((feeling) => feeling.iconName == _selectedFeeling),
      );

      await FirebaseFirestore.instance
          .collection('diary_entries')
          .add(entry.toJson());
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Entry"),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                onSaved: (value) => _title = value ?? '',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Select a feeling',
                    border: OutlineInputBorder()),
                value: _selectedFeeling,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFeeling = newValue!;
                  });
                },
                items:
                    _feelings.map<DropdownMenuItem<String>>((Feeling feeling) {
                  return DropdownMenuItem<String>(
                    value: feeling.iconName,
                    child: Row(
                      children: [
                        Icon(
                          feeling.getIcon(),
                          color: feeling.getColor(),
                        ),
                        const SizedBox(width: 10),
                        Text(feeling.iconName)
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Text', border: OutlineInputBorder()),
                maxLines: 8,
                onSaved: (value) => _text = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
