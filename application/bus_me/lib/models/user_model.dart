
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bus_me/models/auth_model.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

abstract class UserModel
{
  User? getUser();
  //update user
  Future<int> fetchUser();

  //user function CANNOT CREATE ADMIN ACCOUNTS
  Future<int> registerUser(UserRegistration user);

  //user function for settings changes
  Future<int> updateUser();
}

class BusMeUserModel extends UserModel
{
  User? _user;
  final AuthModel _authModel;

  HttpClient userServer = HttpClient(context: SecurityContext.defaultContext);


  BusMeUserModel(this._authModel)
  {
    userServer.badCertificateCallback =  (X509Certificate cert, String host, int port) {
      if (kDebugMode)
      {
        return true;
      }
      return false;

    };
  }

  @override
  Future<int> fetchUser() async {
    //build get request

    userServer.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/users/${_authModel.getUserId()}');

    log(route.toString());
    try {
      HttpClientRequest request = await userServer.getUrl(route);

      request.headers.add("Authorization", "Bearer ${_authModel.getToken()}");

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return 1;
    }
    log(req.statusCode.toString());
    if(req.statusCode != 200)
    {
      return 1;
    }
    //decode json then
    try
    {
      dynamic result = jsonDecode(await req.transform(utf8.decoder).join());

      _user = User.fromJson(result);

    }
    on Exception catch(e)
    {
      return 1;
    }

    //notify observers that i have fetched a user
    return 0;
  }

  @override
  User? getUser() {
    return _user;
  }

  @override
  Future<int> registerUser(UserRegistration user) async {
    Uri route = Uri.https(API_ROUTE,'/api/users/register');
    HttpClientRequest postReq = await userServer.postUrl(route);

    //write user info to network
    postReq.write(jsonEncode(user));

    HttpClientResponse result = await postReq.close();

    if (result.statusCode != HttpStatus.created)
    {
      return 1;
    }

    return 0;
  }

  @override
  Future<int> updateUser() async {

    if (_user == null || !_authModel.isLoggedIn())
    {
      return 1;
    }

    Uri detailRoute = Uri.https(API_ROUTE,'/api/users/${_user!.id}}/details');
    Uri settingsRotue = Uri.https(API_ROUTE,'/api/users/${_user!.id}}/settings');

    HttpClientRequest detailPut = await userServer.putUrl(detailRoute);
    HttpClientRequest settingsPut = await userServer.putUrl(settingsRotue);

    detailPut.headers.add("Authorization", "Bearer ${_authModel.getToken()}");
    settingsPut.headers.add("Authorization", "Bearer ${_authModel.getToken()}");

    detailPut.write(jsonEncode(_user!.details));
    settingsPut.write(jsonEncode(_user!.settings));

    HttpClientResponse detailRes = await detailPut.close();
    HttpClientResponse settingsRes = await settingsPut.close();

    if (detailRes.statusCode != HttpStatus.ok || settingsRes.statusCode != HttpStatus.ok )
    {
      return 1;
    }


    return 0;
  }


}

class UserRegistration {
  String username;

  String password;

  UserDetails details;

  UserRegistration(this.username, this.password, this.details);

}


class UserSettings
{
  bool? audioNotifications = false;
  bool? vibrationNotifications = false;
  int? route;
  UserSettings(this.audioNotifications, this.vibrationNotifications, this.route);
}

class UserDetails
{
  String name;
  String email;
  String phone;

  UserDetails(this.name, this.email, this.phone);
}

class User
{
  UserSettings? settings;
  UserDetails? details;
  String username;
  int id;
  int type;

  User(this.id, this.username, this.settings, this.details, this.type);

  static User fromJson(dynamic sourceObj)
  {
    dynamic? settings = sourceObj["settings"];
    dynamic? details = sourceObj["details"];

    UserSettings? settingsObj;
    UserDetails? detailsObj;

    if (settings != null)
    {
      settingsObj = UserSettings(settings["audioNotifications"], settings["vibrationNotifications"], settings["routeId"]);
    }

    if (details != null)
    {
      detailsObj = UserDetails(details["name"], details["email"], details["phone"]);
    }

    return User(sourceObj["id"], sourceObj["username"], settingsObj, detailsObj, sourceObj["type"]);
  }
}