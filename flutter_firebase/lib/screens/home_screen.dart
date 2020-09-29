import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/all_notes_screen.dart';
import 'package:flutter_firebase/screens/registration_screen.dart';
import 'package:flutter_firebase/widgets/add_note.dart';

class HomeScreeen extends StatefulWidget {
  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen>
    with SingleTickerProviderStateMixin {
  AnimationController _refreshController;

  @override
  void initState() {
    super.initState();

    _refreshController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

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
        leading: AnimatedBuilder(
          animation: _refreshController,
          child: IconButton(
              onPressed: () {
                _refreshController.forward(from: 0);
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.lightGreen,
              )),
          builder: (context, _widget) {
            return Transform.rotate(
              angle: _refreshController.value * 6.3,
              child: _widget,
            );
          },
        ),
        actions: [
          Row(children: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Registration()),
                    (route) => false);
              },
              icon: Icon(Icons.exit_to_app, size: 28, color: Colors.red[400]),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.more_vert, size: 28, color: Colors.white),
            ),
          ])
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
