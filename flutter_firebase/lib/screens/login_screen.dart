import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool showProgress = false;

  Future<bool> loginUser(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        print("result: " + result.toString());
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Note"),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Sign In",
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
                  email = value;
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
                  password = value;
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
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    if (_formKey.currentState.validate()) {
                      bool result = await loginUser(email, password);
                      if (result) {
                        Fluttertoast.showToast(
                            msg: "Sign in Successfully!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreeen()),
                            (route) => false);
                      } else {
                        print("error");
                      }
                    }
                    setState(() {
                      showProgress = false;
                    });
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
