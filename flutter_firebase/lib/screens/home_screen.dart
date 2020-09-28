import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/all_notes_screen.dart';
import 'package:flutter_firebase/screens/registration_screen.dart';
import 'package:flutter_firebase/widgets/add_note.dart';

class HomeScreeen extends StatefulWidget {
  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FirebaseAuth.instance.currentUser.email,
          style: TextStyle(
            fontFamily: "montserrat",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.refresh,
          color: Colors.lightGreen,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                  (route) => false);
            },
            icon: Icon(
              Icons.exit_to_app,size: 28,
              color: Colors.red[400]
            ),
          )
        ],
      ),
      body: AllNotes(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AddNote(),
          );
        },
      ),
    );
  }
}
