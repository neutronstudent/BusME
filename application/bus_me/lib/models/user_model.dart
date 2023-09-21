
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
}

class BusMeUserModel extends UserModel
{
  User? _user;
  final AuthModel _authModel;

  BusMeUserModel(this._authModel);

  @override
  Future<int> fetchUser() async {
    //build get request
    HttpClient userServer = HttpClient(context: SecurityContext.defaultContext);

    userServer.badCertificateCallback =  (X509Certificate cert, String host, int port) {
      if (kDebugMode)
      {
        return true;
      }
      return false;

    };

    userServer.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/users/{${_authModel.getUserId()}}');

    log(route.toString());
    try {
      HttpClientRequest request = await userServer.getUrl(route);

      req = await request.close();
    }
    on SocketException catch (e)
    {
      return 1;
    }
    if(req.statusCode != 200)
    {
      return 1;
    }
    //decode json then
    try
    {
      dynamic result = jsonDecode(await req.transform(utf8.decoder).join());
      
      UserSettings settings = UserSettings(result.settings.audioNotifications, result.settings.vibrationNotifications, result.settings.routeId);
      UserDetails details = UserDetails(result.details.name, result.details.email, result.details.phone);

      _user = User(result.id, result.username, settings, details, result.type);

    }
    on Exception catch(e)
    {
      return 1;
    }

    //notify observers that i have fetched a user
    return 10;
  }

  @override
  User? getUser() {
    return _user;
  }

}


class UserSettings
{
  bool audioNotifications = false;
  bool vibrationNotifications = false;
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
  UserSettings settings;
  UserDetails details;
  String username;
  int id;
  int type;
  User(this.id, this.username, this.settings, this.details, this.type);
}