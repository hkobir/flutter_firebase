import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _activeSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Setting"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Dark theme"),
            leading: Switch(
              value: _activeSwitch,
              activeColor: Theme.of(context).primaryColor,
              activeTrackColor: Colors.brown[300],
              onChanged: (value) {
                setState(() {
                  _activeSwitch = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
