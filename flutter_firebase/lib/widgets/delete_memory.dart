import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteMemory extends StatefulWidget {
  String memoryId;

  DeleteMemory({this.memoryId});

  @override
  _DeleteMemoryState createState() => _DeleteMemoryState();
}

class _DeleteMemoryState extends State<DeleteMemory> {
  bool showProgress = false;

  Future<bool> deleteNote() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("images")
        .doc(widget.memoryId)
        .delete()
        .then((value) {
      return true;
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
      setState(() {
        showProgress = false;
      });

      print(e);
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you Sure to delete this memory?"),
      elevation: 2,
      actions: [
        FlatButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () async {
            _navigateToLastScreen();

            setState(() {
              showProgress = true;
            });

            bool result = await deleteNote();
            if (result) {
              Fluttertoast.showToast(msg: "memory deleted",toastLength: Toast.LENGTH_SHORT);
            }
          },
        ),
        FlatButton(
          child: Text(
            "No",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            _navigateToLastScreen();
          },
        ),
      ],
    );
  }

  void _navigateToLastScreen() {
    Navigator.pop(context);
  }
}
