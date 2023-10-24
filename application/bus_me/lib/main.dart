import 'package:bus_me/controllers/login_controller.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/models/notification_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/views/login.dart';
import 'package:flutter/material.dart';



void main() {

  AuthModel authModel = BusMEAuth();
  BusMEUserManagement userManagementModel = BusMEUserManagement(authModel);
  BusMEUserModel userModel = BusMEUserModel();

  NotificationModel().initNotifications();

  NotificationModel().addNotifType(NotifType.ALERT);
  NotificationModel().addNotifType(NotifType.TTS);

  LoginController loginController = LoginController();

  runApp(MaterialApp(
    home: LoginScreen(
    ),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Helvetica',
    ),
  ));
}

