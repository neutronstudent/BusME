import 'package:flutter/material.dart';
import 'package:bus_me/views/login.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isAudioEnabled = false;
  bool isVibrationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Checkbox for Audio notifications
            ListTile(
              title: Text('Audio notifications'),
              trailing: Checkbox(
                value: isAudioEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    isAudioEnabled = value ?? false;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  isAudioEnabled = !isAudioEnabled;
                });
              },
            ),
            // Checkbox for Vibration notifications
            ListTile(
              title: Text('Vibration notifications'),
              trailing: Checkbox(
                value: isVibrationEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    isVibrationEnabled = value ?? false;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  isVibrationEnabled = !isVibrationEnabled;
                });
              },
            ),
            // Spacer for aligning the Logout button to the bottom
            Spacer(),
            // Logout button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
