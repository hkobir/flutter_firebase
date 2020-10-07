import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/memory_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddMemory extends StatefulWidget {
  String picker;

  AddMemory({this.picker});

  @override
  _AddMemoryState createState() => _AddMemoryState();
}

class _AddMemoryState extends State<AddMemory> {
  bool showProgress = false;
  String title;
  String imageLink;
  File _image;

  Future<bool> insertMemory(final memory) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var result = await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("images")
        .add(memory)
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

  Future getImage() async {
    File img;
    if (widget.picker == "camera") {
      await ImagePicker.platform
          .pickImage(source: ImageSource.camera)
          .then((pickedFile) => img = File(pickedFile.path));
    } else if (widget.picker == "gallery") {
      await ImagePicker.platform
          .pickImage(source: ImageSource.gallery)
          .then((pickedFile) => img = File(pickedFile.path));
    }
    setState(() {
      _image = img;
      showProgress = true;
    });

    //upload image to storage
    FirebaseStorage fs = FirebaseStorage.instance;
    StorageReference storageReference = fs.ref();
    storageReference
        .child("memories")
        .child("image_${DateTime.now().millisecondsSinceEpoch}")
        .putFile(_image)
        .onComplete
        .then((task) async {
      String link = await task.ref.getDownloadURL();
      setState(() {
        imageLink = link;
        showProgress = false;
      });
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Image uploaded"),
      duration: Duration(seconds: 1),
    ));
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
    ;
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Add Memory",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.clear,
                      size: 30,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image == null
                    ? GestureDetector(
                        onTap: getImage,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 70,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200], shape: BoxShape.circle),
                        ),
                      )
                    : Image.file(
                        _image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                      labelText: "Memory Title",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1)),
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
                      if (imageLink != null) {
                        final Memory memory =
                            Memory(title: title, imageUrl: imageLink);
                        bool result =
                            await insertMemory(memory.memoryModelToMap());
                        if (result) {
                          Fluttertoast.showToast(
                              msg: "Memory added",
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
          )
        ],
      ),
    );
  }
}
