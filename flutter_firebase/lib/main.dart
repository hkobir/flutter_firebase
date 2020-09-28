import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme:
        ThemeData(
            primaryColor: Colors.brown,
            accentColor: Colors.brown[400],
        ),
    home: SplashScreen(),
  ));
}
