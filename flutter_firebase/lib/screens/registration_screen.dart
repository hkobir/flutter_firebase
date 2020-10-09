import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/login_screen.dart';
import 'package:flutter_firebase/screens/main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  String email, password, confirmPassword;
  bool showProgress = false;

  Future<bool> registerUser(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null)
        return true;
      else
        return false;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login())),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: Text("Daily Note"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value.toString().trim();
                      ;
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.grey[150],
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value.toString().trim();
                      ;
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.grey[150],
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter confirm password";
                      } else if (value != password) {
                        return "Please enter valid password as previous";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      confirmPassword = value.toString().trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Confirm password",
                      filled: true,
                      fillColor: Colors.grey[150],
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 0.5)),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: FlatButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        print("email: " + email + " pass: " + password);

                        setState(() {
                          showProgress = true;
                        });
                        if (_formKey.currentState.validate()) {
                          bool result = await registerUser(email, password);
                          if (result) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          } else {
                            print("error");
                            Fluttertoast.showToast(
                                msg: "Incorrect email or password");
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
          ),
        ),
      ),
    );
  }
}
