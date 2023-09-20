import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';
import 'package:bus_me/views/admin_view.dart';
import 'package:bus_me/views/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthModel BusMEAuth;
  final LoginController loginController;

  LoginScreen({required this.BusMEAuth, required this.loginController});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                widget.loginController.notify(ObsSignal(
                    "login", {"username": username, "password": password}),);

                if (widget.BusMEAuth.isLoggedIn()) {
                  if (username == "admin") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminView()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MapView()));
                  }
                } else {
                  //create a popup saying login unsuccessful
                }
              },

              child: Text('Login'),
            ),
          ],
        ),)
      ,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
