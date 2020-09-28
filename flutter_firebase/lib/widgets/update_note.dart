import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/note_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UpdateNote extends StatefulWidget {
  String noteId, title, details;

  UpdateNote({this.noteId, this.title, this.details});

  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  String titleText, detailText;
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;

  Future<bool> updateNote(final note) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("notes")
        .doc(widget.noteId)
        .update(note)
        .catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
      setState(() {
        showProgress = false;
      });

      print(e);
      return false;
    });

    return true;
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
                    "Update Note",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: widget.title,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter note title";
                      }
                    },
                    onChanged: (value) {
                      titleText = value;
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
                    initialValue: widget.details,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter note details";
                      }
                    },

                    onChanged: (value) {
                      detailText = value;
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
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });
                        if (_formKey.currentState.validate()) {
                          final Note note = Note(
                              title: titleText,
                              details: detailText
                          );
                          bool result = await updateNote(note.noteModelToMap());
                          if (result) {
                            Fluttertoast.showToast(
                                msg: "Note Updated",
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
