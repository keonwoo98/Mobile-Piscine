import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/models/feeling.dart';
import 'package:diaryapp/screens/entry_detail_page.dart';
import 'package:intl/intl.dart';

class EntriesList extends StatelessWidget {
  final Stream<QuerySnapshot> entryStream;
  final bool isScrollable;

  const EntriesList({
    Key? key,
    required this.entryStream,
    this.isScrollable = false,
  }) : super(key: key);

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: entryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No entries found'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: isScrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var entryModel = Entry.fromSnapshot(snapshot.data!.docs[index]);
            String formattedDate = formatTimestamp(doc['date']);
            IconData icon = Feeling.getIcon(doc['icon']);
            Color iconColor = Feeling.getColor(doc['icon']);

            return Container(
              margin: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(doc['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(formattedDate),
                trailing: Icon(icon, color: iconColor),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EntryDetailPage(entry: entryModel)));
                },
              ),
            );
          },
        );
      },
    );
  }
}
