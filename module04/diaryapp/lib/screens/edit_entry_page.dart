import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/models/feeling.dart';

class EditEntryPage extends StatefulWidget {
  final Entry entry;

  const EditEntryPage({Key? key, required this.entry}) : super(key: key);

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _text;
  late String _selectedFeeling;

  @override
  void initState() {
    super.initState();
    _title = widget.entry.title;
    _text = widget.entry.text;
    _selectedFeeling = widget.entry.icon;
  }

  Future<void> _updateEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection('diary_entries')
          .doc(widget.entry.id)
          .update({
        'title': _title,
        'text': _text,
        'icon': _selectedFeeling,
      });

      Entry modifiedEntry = Entry(
        id: widget.entry.id,
        title: _title,
        text: _text,
        date: widget.entry.date,
        userMail: widget.entry.userMail,
        icon: _selectedFeeling,
      );
      if (mounted) {
        Navigator.pop(context, modifiedEntry);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select a feeling',
                  border: OutlineInputBorder(),
                ),
                value: _selectedFeeling,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFeeling = newValue!;
                  });
                },
                items: [
                  'very_dissatisfied',
                  'dissatisfied',
                  'neutral',
                  'satisfied',
                  'very_satisfied'
                ].map<DropdownMenuItem<String>>((String feeling) {
                  return DropdownMenuItem<String>(
                    value: feeling,
                    child: Row(
                      children: [
                        Icon(
                          Feeling.getIcon(feeling),
                          color: Feeling.getColor(feeling),
                        ),
                        const SizedBox(width: 10),
                        Text(feeling.replaceAll('_', ' ').capitalize()),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _text,
                decoration: const InputDecoration(
                    labelText: 'Text', border: OutlineInputBorder()),
                maxLines: 8,
                onSaved: (value) => _text = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEntry,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
