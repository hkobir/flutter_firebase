import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/delete_memory.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllMemory extends StatefulWidget {
  @override
  _AllMemoryState createState() => _AllMemoryState();
}

class _AllMemoryState extends State<AllMemory> {
  static const menuItems = <String>['Delete'];
  var _tapPosition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("images")
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
                  "Empty Memory!",
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
    return GridView.count(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(snapshot.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onLongPress: () async {
              String select = await _showmenu(context);
              if (select == menuItems[0]) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => DeleteMemory(
                          memoryId: snapshot[index].id,
                        ));
              }
            },
            onTapDown: _storePosition,
            child: Stack(children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6.0)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(snapshot[index].data()['imageUrl']),
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      child: snapshot[index].data()['title'] != null
                          ? Text(
                              snapshot[index].data()['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : SizedBox()))
            ]),
          ),
        );
      }),
    );
  }

  final List<PopupMenuItem<String>> _popUpMenuItem = menuItems
      .map((value) => PopupMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  Future<String> _showmenu(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    String selected = await showMenu<String>(
        context: context,
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), Offset.zero & overlay.size),
        initialValue: menuItems[0],
        items: _popUpMenuItem);

    return selected;
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}
