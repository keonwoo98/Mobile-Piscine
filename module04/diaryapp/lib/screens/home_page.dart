import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/screens/entry_creation_page.dart';
import 'package:diaryapp/screens/entry_detail_page.dart';
import 'package:diaryapp/models/entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Diary Entries'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('diary_entries')
            .where('userMail', isEqualTo: user?.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No entries found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var entry = snapshot.data!.docs[index];
              String formattedDate = formatTimestamp(entry['date']);
              return Container(
                margin: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(entry['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(formattedDate),
                  onTap: () {
                    // Firestore 문서 스냅샷을 Entry 객체로 변환
                    final entry =
                        Entry.fromSnapshot(snapshot.data!.docs[index]);

                    // Entry 객체를 EntryDetailPage에 전달
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EntryDetailPage(entry: entry),
                    ));
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // 엔트리 삭제 로직
                      _firestore
                          .collection('diary_entries')
                          .doc(entry.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const EntryCreationPage(),
          ));
        },
      ),
    );
  }
}
