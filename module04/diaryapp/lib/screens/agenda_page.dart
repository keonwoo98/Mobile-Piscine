import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diaryapp/screens/entry_detail_page.dart';
import 'package:diaryapp/models/entry.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // 이 부분을 추가해야 캘린더가 올바르게 작동합니다.
              });
              // 선택된 날짜에 해당하는 일기 목록을 표시하는 기능을 여기에 구현합니다.
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('diary_entries')
                  .where('userMail',
                      isEqualTo: FirebaseAuth.instance.currentUser?.email)
                  .where('date',
                      isEqualTo:
                          _selectedDay) // Firestore에서 날짜 필터링 방식에 따라 적절히 조정 필요
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No entries found for this day'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var entry = Entry.fromSnapshot(doc);
                    return ListTile(
                      title: Text(entry.title),
                      subtitle: Text(entry.text), // 간략한 내용 표시
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EntryDetailPage(entry: entry))),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
