import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/screens/memory_screen.dart';
import 'package:flutter_firebase/screens/registration_screen.dart';
import 'package:flutter_firebase/screens/setting_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  PageController _pageController;
  AnimationController _refreshController;
  static const menuItems = <String>['Setting', 'Exit'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _refreshController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          FirebaseAuth.instance.currentUser.email,
          style: TextStyle(
              fontFamily: "montserrat", color: Colors.white, fontSize: 16),
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
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "Setting") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting()));
                } else {
                  SystemNavigator.pop(); //exit from app
                }
              },
              itemBuilder: (context) => _popUpMenuItem,
            ),
          ])
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[HomeScreeen(), MemoryScreen()],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.grey[300],
        showElevation: true,
        mainAxisAlignment: MainAxisAlignment.center,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Notes',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              icon: Icon(Icons.note),
              textAlign: TextAlign.center,
              activeColor: Theme.of(context).accentColor),
          BottomNavyBarItem(
              title: Text('Memories',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              icon: Icon(Icons.photo_library),
              activeColor: Theme.of(context).accentColor),
        ],
      ),
    );
  }

  final List<PopupMenuItem<String>> _popUpMenuItem = menuItems
      .map((value) => PopupMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
}
