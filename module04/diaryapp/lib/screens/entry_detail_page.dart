import 'package:diaryapp/models/feeling.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diaryapp/screens/edit_entry_page.dart';
import 'package:diaryapp/models/entry.dart';

class EntryDetailPage extends StatefulWidget {
  final Entry entry;

  const EntryDetailPage({Key? key, required this.entry}) : super(key: key);

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late Entry _currentEntry;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_currentEntry.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentEntry.title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final modifiedEntry = await Navigator.push<Entry>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry: _currentEntry),
                ),
              );

              if (modifiedEntry != null) {
                setState(() {
                  _currentEntry = modifiedEntry;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Feeling.getIcon(_currentEntry.icon),
                        color: Feeling.getColor(_currentEntry.icon),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _currentEntry.icon,
                        style: TextStyle(
                          fontSize: 18,
                          color: Feeling.getColor(_currentEntry.icon),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentEntry.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
