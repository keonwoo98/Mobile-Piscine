import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diaryapp/widgets/entries_list.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_focusedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: EntriesList(
              entryStream: FirebaseFirestore.instance
                  .collection('diary_entries')
                  .where('userMail',
                      isEqualTo: FirebaseAuth.instance.currentUser?.email)
                  .where('date',
                      isGreaterThanOrEqualTo: DateTime(
                          _focusedDay.year, _focusedDay.month, _focusedDay.day))
                  .where('date',
                      isLessThan: DateTime(_focusedDay.year, _focusedDay.month,
                          _focusedDay.day + 1))
                  .snapshots(),
              isScrollable: true,
            ),
          ),
        ],
      ),
    );
  }
}
