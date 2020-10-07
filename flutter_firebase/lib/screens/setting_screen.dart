import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _activeSwitch = false;
  Color textColor = Colors.black;
  Color backColor = Colors.white;

  @override
  void initState() {
    super.initState();
    getStoredValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text("Edit Setting"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Dark theme",
              style: TextStyle(color: textColor),
            ),
            trailing: Switch(
              value: _activeSwitch,
              activeColor: Theme.of(context).primaryColor,
              activeTrackColor: Colors.brown[300],
              onChanged: (value) {
                setState(() {
                  _activeSwitch = value;
                  addValueToSF(value);
                  setTheme();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  void addValueToSF(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchStatus", value);
  }

  void setTheme() {
    if (_activeSwitch) {
      textColor = Colors.white;
      backColor = Colors.black54;
    } else {
      textColor = Colors.black54;
      backColor = Colors.white;
    }
  }

  void getStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _activeSwitch = await prefs.getBool("switchStatus") ?? false;
    print("stored value: $_activeSwitch");
    setState(() {
      setTheme();
    });
  }
}
