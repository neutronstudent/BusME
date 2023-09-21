import 'dart:io';

import 'package:bus_me/controllers/login_controller.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';
import 'package:bus_me/views/login.dart';
import 'package:flutter/material.dart';
import 'views/map_view.dart';
import 'views/admin_view.dart';

import 'package:flutter/services.dart';



void main() {
  AuthModel authModel = BusMEAuth();
  LoginController loginController = LoginController(authModel);

  runApp(MaterialApp(
    home: LoginScreen(
      BusMEAuth: authModel,
      loginController: loginController,
    ),
  ));
}

class LoginView extends StatelessWidget {
  final AuthModel authModel;
  final LoginController loginController;

  LoginView({required this.authModel, required this.loginController});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BusMe Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(BusMEAuth: authModel, loginController: loginController,),
    );
  }
}

