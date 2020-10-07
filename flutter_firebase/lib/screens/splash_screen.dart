import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/main_screen.dart';
import 'package:flutter_firebase/screens/registration_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          //signed out state
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Registration()));
        } else {
          //signed in state
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage("assets/images/logo.png"),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Mind It",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "montserrat",
                    fontSize: 22,
                    color: CupertinoColors.white),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
