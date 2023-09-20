import 'dart:io';

import 'package:bus_me/controllers/login_controller.dart';
import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';
import 'package:bus_me/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void  main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  BusMEAuth auth = BusMEAuth();
  LoginController loginController = LoginController(auth);
  LoginPage loginPage = LoginPage();

  ByteData cert = await PlatformAssetBundle().load("assets/ca/lets-encrypt-r3.pem");
  SecurityContext.defaultContext.setTrustedCertificatesBytes(cert.buffer.asUint8List());
  
  loginPage.loginObservable.addObserver(loginController);



  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(
        body: loginPage
      )
    )
  );
}
