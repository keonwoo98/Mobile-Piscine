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
  final List<Feeling> _feelings = [
    Feeling(iconName: "dissatisfied"),
    Feeling(iconName: "very_dissatisfied"),
    Feeling(iconName: "neutral"),
    Feeling(iconName: "satisfied"),
    Feeling(iconName: "very_satisfied"),
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.entry.title;
    _text = widget.entry.text;
    _selectedFeeling = widget.entry.feeling.iconName;
  }

  Future<void> _updateEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Firestore에 업데이트
      await FirebaseFirestore.instance
          .collection('diary_entries')
          .doc(widget.entry.id)
          .update({
        'title': _title,
        'text': _text,
        'feeling': _selectedFeeling, // Firestore에는 업데이트가 반영됨
      });

      // 수정된 Entry 객체 생성
      Entry modifiedEntry = Entry(
        id: widget.entry.id,
        title: _title,
        text: _text,
        date: widget.entry.date,
        userMail: widget.entry.userMail,
        icon: _selectedFeeling, // 여기서 icon을 _selectedFeeling으로 설정
        feeling: _feelings.firstWhere((feeling) =>
            feeling.iconName == _selectedFeeling), // 새로운 Feeling 객체 생성
      );

      if (mounted) {
        Navigator.pop(context, modifiedEntry); // 수정된 Entry 객체를 반환
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Entry"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                initialValue: _text,
                decoration: const InputDecoration(
                    labelText: 'Text', border: OutlineInputBorder()),
                maxLines: 8,
                onSaved: (value) => _text = value!,
              ),
              const SizedBox(height: 20),
              // 여기에 감정을 선택할 수 있는 DropdownButtonFormField 추가
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
