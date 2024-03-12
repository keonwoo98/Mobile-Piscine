import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/screens/entry_creation_page.dart';
import 'package:diaryapp/widgets/entries_list.dart';
import 'package:diaryapp/widgets/feeling_ratios.dart';

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
            EntriesList(
              entryStream: _firestore
                  .collection('diary_entries')
                  .where('userMail', isEqualTo: user?.email)
                  .orderBy('date', descending: true)
                  .limit(2)
                  .snapshots(),
            ),
            FeelingRatios(userEmail: user?.email),
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
}
