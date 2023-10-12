import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bus_me/models/api_constants.dart';
import 'package:bus_me/observable.dart';
import 'package:flutter/foundation.dart';




//class for interacting with API

abstract class AuthModel extends Observable
{
  String? getToken();
  int? getUserId();
  bool isLoggedIn();
  Future<int> loginUser(String username, String password);
  int logout();
}


class BusMEAuth extends AuthModel {

  static final BusMEAuth _instance = BusMEAuth._internal();

  factory BusMEAuth() {
    return _instance;
  }

  BusMEAuth._internal();

  //
  String? _token = "";
  int? _id;

  //return token if exists
  @override
  String? getToken()
  {
    return _token;
  }

  int? getUserId()
  {
    return _id;
  }

  //attempt to login to BusME
  @override
  Future<int> loginUser(String username, String password) async
  {
    //build get request
    HttpClient authServer = HttpClient(context: SecurityContext.defaultContext);

    authServer.badCertificateCallback =  (X509Certificate cert, String host, int port) {
      if (kDebugMode)
      {
        return true;
      }
      return false;

    };

    authServer.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/auth/login', {'username': username, 'password': password});
    log(route.toString());

    try {
      HttpClientRequest request = await authServer.getUrl(route);

      req = await request.close();
    }
    on SocketException catch (e)
    {
      log("failed login network");
      notifyObservers(ObsSignal("failed-login-network", {}));
      return 1;
    }


    if (req.statusCode != 200)
    {
      log("Failled login info");
      notifyObservers(ObsSignal("failed-login-incorrect", {}));
      return 1;
    }



    log("Login Succided");
    String source = await req.transform(utf8.decoder).join();

    try {
      dynamic result = jsonDecode(source);

      _token = result["token"];

      _id = result["id"];
    }
    on Exception catch(e)
    {
      return 1;
    }

    //notify observers that i have logged_in
    if (isLoggedIn())
    {

      notifyObservers(ObsSignal("logged-in", {}));
      return 0;

    }
    //notify observes that login has failed
    return 1;
  }

  @override
  bool isLoggedIn()
  {
    //check if token is present for now
    //need to pass expiry in the future...
    return _token != null && _token!.isNotEmpty;
  }

  @override
  int logout() {

    _token = null;
    _id = null;

    return 1;
  }


}
