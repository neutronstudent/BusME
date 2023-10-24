import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:bus_me/views/login.dart';
import '../models/bus_model.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isAudioEnabled = false;
  bool isVibrationEnabled = false;

  UserModel _userModel = BusMEUserModel();
  BusModel _busModel = BusModel();

  late Future<List<BusRoute>> routesFuture;  // Store the future for bus routes

  @override
  void initState() {
    super.initState();
    routesFuture = _busModel.getRoutes();  // Fetch the routes when widget is first loaded
  }

  _SettingsPageState()
  {
    final user = _userModel.getUser();
    if (user != null && user.settings != null) {
      this.isAudioEnabled = user.settings?.audioNotifications ?? false;
      this.isVibrationEnabled = user.settings?.vibrationNotifications ?? false;
    } else {
      this.isAudioEnabled = false;
      this.isVibrationEnabled = false;
    }
  }

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
              onTap: ()  {
                setState(() async {
                  isAudioEnabled = !isAudioEnabled;
                  _userModel.getUser()!.settings?.audioNotifications = isAudioEnabled;
                  await _userModel.updateUser();
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
                setState(() async {
                  isVibrationEnabled = !isVibrationEnabled;
                  _userModel.getUser()!.settings?.vibrationNotifications = isVibrationEnabled;
                  await _userModel.updateUser();
                });
              },
            ),
            // List of Bus Routes
            Expanded(
              child: FutureBuilder<List<BusRoute>>(
                future: routesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());  // Show loading indicator while data is being fetched
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load bus routes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No bus routes available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final route = snapshot.data![index];
                        return ListTile(
                          title: Text(route.name),
                          subtitle: Text(route.code),
                          onTap: () {
                            _handleRouteSelection(route.id);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // Spacer for aligning the Logout button to the bottom
            Spacer(),
            // Logout button
            ElevatedButton(
              onPressed: () {

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRouteSelection(int routeId) async {
    _userModel.getUser()!.settings?.route = routeId;
    await _userModel.updateUser();
    AlertDialog(
      title: Text('Route Selection'),
      content: Text('The route has been added to your account successfully'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    );
  }
}
