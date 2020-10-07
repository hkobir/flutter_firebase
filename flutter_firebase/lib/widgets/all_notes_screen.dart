import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/widgets/delete_note.dart';
import 'package:flutter_firebase/widgets/details_bottom_sheets.dart';
import 'package:flutter_firebase/widgets/update_note.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AllNotes extends StatefulWidget {


  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("notes")
          .snapshots(),
      builder: (context, querySnapshot) {
        if (querySnapshot.hasError) {
          Fluttertoast.showToast(msg: "Some error!");
          print("error: " + querySnapshot.error.toString());
          return Text("Some snapshot  Error");
        }
        if (querySnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (querySnapshot.data.docs.length <= 0 ||
            querySnapshot.data.docs == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.block,
                  size: 28,
                  color: Colors.red,
                ),
                Text(
                  "Empty Note!",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          );
        }
        if (querySnapshot.hasData) {
          return _buildnoteData(context, querySnapshot.data.docs);
        }
      },
    );
  }

  Widget _buildnoteData(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => ShowDetail(
                          title: snapshot[index].data()['title'],
                          details: snapshot[index].data()['details'],
                        ));
              },
              child: Card(
                elevation: 3,
                color: Colors.grey[100],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Text(
                            snapshot[index].data()['title'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: "montserrat"),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(snapshot[index].data()['details'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("Note Id: " + snapshot[index].id);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => UpdateNote(
                                  noteId: snapshot[index].id,
                                  title: snapshot[index].data()['title'],
                                  details: snapshot[index].data()['details'],
                                ),
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    (BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 3))
                                  ]),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => DeleteNote(
                                  noteId: snapshot[index].id,
                                ),
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    (BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 3))
                                  ]),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
