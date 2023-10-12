import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:bus_me/views/admin_portal.dart';
import 'package:bus_me/views/map_view.dart';

class LoginController implements Observer {
  static final LoginController _instance = LoginController._internal(BusMEAuth(), BusMEUserModel());


  final AuthModel _authModel = BusMEAuth();
  final BusMEUserModel _busMEUserManagement = BusMEUserModel();
  final UserModel _userModel = BusMEUserModel();

  factory LoginController() {
    return _instance;
  }

  LoginController._internal(_authModel, _busMEUserManagement);

  @override
  Future<void> notify(ObsSignal notification) async {
    if (notification.type == "login") {
      await _authModel.loginUser(notification.parameters["username"], notification.parameters["password"]);
    }
  }

  Future<bool> createAccount(String username, String password, String name, String email, String phone) async {
    bool created = false;

    UserDetails userDetails = UserDetails(name, email, phone);
    UserRegistration userRegistration = UserRegistration(username, password, userDetails);

    if (await _busMEUserManagement.registerUser(userRegistration) == 0) {
      created = true;
    }

    return created;
  }

  Future<void> login(BuildContext context, usernameController, passwordController) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

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
    int loginResult = await _authModel.loginUser(username, password);

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

    await _userModel.fetchUser();

    User? user = _userModel.getUser();

    if (user != null) {
      int userType = user.type;

      if (userType == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AdminPortal(),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapPage(),
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
}
