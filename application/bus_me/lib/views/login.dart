import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import 'create_account_screen.dart';
import '../controllers/login_controller.dart';
import 'mapView.dart';

import 'package:bus_me/views/map_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BusMe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [

                ElevatedButton(
                  onPressed: //() => _loginController.login(context, _usernameController, _passwordController),
                  () { Navigator.push(context, MaterialPageRoute(builder: (context) => MapView()), ); }, //only for testing purposes
                  child: Text('Login'),
                ),
                SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountScreen()
                      ),
                      );

                    },
                    child: Text('Create Account'),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationModel().sendNotification("Your Bus is Arriving! Press OK to Dismiss", context);
                  },
                  child: Text('Test Message'),
                )
                ]
                ),
              ],
            ),
          ),
        );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
