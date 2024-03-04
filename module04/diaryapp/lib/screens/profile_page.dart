import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/models/entry.dart';
import 'package:diaryapp/screens/entry_creation_page.dart';
import 'package:diaryapp/screens/entry_detail_page.dart';
import 'package:diaryapp/models/feeling.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

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

  Stream<Map<String, double>> fetchFeelingRatiosStream() {
    return _firestore
        .collection('diary_entries')
        .where('userMail', isEqualTo: user?.email)
        .snapshots()
        .map((snapshot) {
      Map<String, int> feelingCounts = {};
      for (var doc in snapshot.docs) {
        String feeling = doc['icon'];
        feelingCounts[feeling] = (feelingCounts[feeling] ?? 0) + 1;
      }

      final totalEntries = snapshot.docs.length;
      return feelingCounts.map((feeling, countValue) =>
          MapEntry(feeling, countValue / totalEntries.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(user?.displayName ?? 'Guest',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _signOut(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEntriesList(),
            _buildFeelingRatios(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const EntryCreationPage()));
        },
      ),
    );
  }

  Widget _buildEntriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('diary_entries')
          // .where('userMail', isEqualTo: user?.email)
          .orderBy('date', descending: true)
          .limit(2)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No entries found'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                  final entry = Entry.fromSnapshot(snapshot.data!.docs[index]);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EntryDetailPage(entry: entry)));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
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
    );
  }

  Widget _buildFeelingRatios() {
    return StreamBuilder<Map<String, double>>(
      stream: fetchFeelingRatiosStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: snapshot.data!.entries
                  .map((entry) => ListTile(
                        leading:
                            Icon(Feeling.fromIconName(entry.key).getIcon()),
                        title:
                            Text('${(entry.value * 100).toStringAsFixed(1)}%'),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
