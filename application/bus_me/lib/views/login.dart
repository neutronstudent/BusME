// #import 'package:bus_me/views/main_map_page.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/views/admin_portal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'package:bus_me/main_map_page.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthModel BusMEAuth;
  final LoginController loginController;
  final UserModel userModel;


  LoginScreen({required this.BusMEAuth, required this.loginController, required this.userModel});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Show alert that username or password is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing'),
            content: Text('Please enter both username and password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Attempt to login
    int loginResult = await widget.BusMEAuth.loginUser(username, password);

    if (loginResult != 0) {
      // Show login failed alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Incorrect username or password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // At this point, login is successful.
    // Determine user type and navigate accordingly.

    await widget.userModel.fetchUser();

    User? user = widget.userModel.getUser();

    if (user != null) {
      int userType = user.type;

      if (userType == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdminPortal(widget.BusMEAuth),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapPage(user: widget.userModel),
        ));
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Does not exist'),
            content: Text('User does not exist'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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

              // This is the new Row widget
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [

                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountScreen(
                          loginController: widget.loginController,
                          BusMEAuth: widget.BusMEAuth)
                        ),
                      );

                    },
                    child: Text('Create Account'),
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
