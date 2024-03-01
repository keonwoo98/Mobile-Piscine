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
  late Entry _currentEntry; // 현재 페이지의 Entry 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry; // widget.entry의 값을 _currentEntry에 복사
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy년 MM월 dd일').format(_currentEntry.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentEntry.title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // 수정 페이지로 이동하고, 수정된 Entry 객체를 받습니다.
              final modifiedEntry = await Navigator.push<Entry>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry: _currentEntry),
                ),
              );

              // 수정된 Entry 객체로 현재 상태 업데이트
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
        // 긴 텍스트에 대응하기 위해 SingleChildScrollView 추가
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            // Material 디자인 카드 사용
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey, // 날짜 색상 조정
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        widget.entry.feeling.getIcon(),
                        color: widget.entry.feeling.getColor(),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.entry.feeling.iconName, // 감정 이름 표시
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.entry.feeling.getColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.entry.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // 텍스트 스타일 조정
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
