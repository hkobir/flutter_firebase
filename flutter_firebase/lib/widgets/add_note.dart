import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/note_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  String title, noteId, details;
  bool showProgress = false;

  Future<bool> insertNote(final note) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var result = await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("notes")
        .add(note)
        .catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
      setState(() {
        showProgress = false;
      });

      print(e);
      return false;
    });
    if (result != null) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Dialog(
          elevation: 1,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: dialogContent(context),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  size: 30,
                  color: Colors.grey,
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Note",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter note title";
                      }
                    },
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Note Title",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter note details";
                      }
                    },
                    onChanged: (value) {
                      details = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Note Details",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: FlatButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });
                        if (_formKey.currentState.validate()) {
                          String date =
                              DateFormat.yMMMd().format(DateTime.now());
                          final Note note =
                              Note(title: title, details: details, date: date);
                          bool result = await insertNote(note.noteModelToMap());
                          if (result) {
                            Fluttertoast.showToast(
                                msg: "Note added",
                                toastLength: Toast.LENGTH_SHORT);
                            Navigator.pop(context);
                          }
                        }
                        setState(() {
                          showProgress = false;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
