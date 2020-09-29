import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DeleteNote extends StatefulWidget {
  String noteId;

  DeleteNote({this.noteId});

  @override
  _DeleteNoteState createState() => _DeleteNoteState();
}

class _DeleteNoteState extends State<DeleteNote> {
  bool showProgress = false;

  Future<bool> deleteNote() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("notes")
        .doc(widget.noteId)
        .delete()
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
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 15, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.picture_in_picture,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Are you sure to delete this note?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    showProgress = true;
                  });

                  bool result = await deleteNote();
                  if (result) {
                    Fluttertoast.showToast(msg: "Note deleted");
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      (BoxShadow(
                          offset: Offset(0, 3),
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 3))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Delete",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(width: 35),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      (BoxShadow(
                          offset: Offset(0, 3),
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 3))
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Cancel",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
