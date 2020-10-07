import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'file:///D:/Flutter/flutter_firebase/flutter_firebase/lib/widgets/all_notes_screen.dart';
import 'package:flutter_firebase/widgets/add_note.dart';

class HomeScreeen extends StatefulWidget {
  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AllNotes(),
        floatingActionButton: FloatingActionButton(
          mini: true,
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
        ));
  }
}
