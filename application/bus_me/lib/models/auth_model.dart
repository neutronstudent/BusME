import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:bus_me/controllers/login_controller.dart';
import 'package:bus_me/models/api_constants.dart';
import 'package:bus_me/observable.dart';
import 'package:http/http.dart' as http;




//class for interacting with API

abstract class AuthModel extends Observable
{
  String? getToken();
  bool isLoggedIn();
  Future<int> loginUser(String username, String password);
}


class BusMEAuth extends AuthModel {

  //
  String? _token = "";


  //return token if exists
  @override
  String? getToken()
  {
    return _token;
  }

  //attempt to login to BusME
  @override
  Future<int> loginUser(String username, String password) async
  {
    //build get request
    HttpClient authServer = HttpClient(context: SecurityContext.defaultContext);

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

    log("Login Succieded");
    _token = await req.transform(utf8.decoder).join();

    if (isLoggedIn())
    {

      notifyObservers(ObsSignal("logged-in", {}));
      return 0;

    }
    //notify observers that i have logged_in
    return 1;
  }

  @override
  bool isLoggedIn()
  {
    //check if token is present for now
    //need to pass expiry in the future...
    return _token != null && _token!.isNotEmpty;
  }

}
