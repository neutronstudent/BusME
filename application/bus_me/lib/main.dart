import 'package:bus_me/controllers/login_controller.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/views/login.dart';
import 'package:flutter/material.dart';



void main() {
  AuthModel authModel = BusMEAuth();
  BusMEUserManagement userManagementModel = BusMEUserManagement(authModel);
  LoginController loginController = LoginController(authModel, userManagementModel);

  runApp(MaterialApp(
    home: LoginScreen(
      BusMEAuth: authModel,
      loginController: loginController,
    ),
  ));
}


