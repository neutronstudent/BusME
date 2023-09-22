

import 'dart:convert';
import 'dart:io';

import 'package:bus_me/models/user_model.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';
import 'auth_model.dart';

abstract class UserManagementModel
{
  //get all users that match query
  Future<List<User>> searchUser(String query);

  //create user But with extra perms
  Future<int> createUser(UserRegistration info, int userType);

  // delete target user
  Future<int> deleteUser(int id);

  //update the user at ID to the new user object
  Future<int> updateUser(int id, User user);

  Future<User?> getUser(int id);
}

class BusMEUserManagement extends UserManagementModel
{
  final AuthModel _authModel;

  HttpClient userServer = HttpClient(context: SecurityContext.defaultContext);

  BusMEUserManagement(this._authModel) {
    userServer.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (kDebugMode) {
        return true;
      }
      return false;
    };
  }

  @override
  Future<int> createUser(UserRegistration user, int userType) async {
    Uri route = Uri.https(API_ROUTE,'/api/users',  {'type': userType});
    HttpClientRequest postReq = await userServer.postUrl(route);

    postReq.headers.add(HttpHeaders.authorizationHeader, _authModel.getToken().toString());

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
  Future<int> deleteUser(int id) async {
    Uri route = Uri.https(API_ROUTE,'/api/users/${id}');
    HttpClientRequest delReq = await userServer.deleteUrl(route);

    delReq.headers.add(HttpHeaders.authorizationHeader, _authModel.getToken().toString());


    HttpClientResponse result = await delReq.close();

    if (result.statusCode != HttpStatus.ok)
    {
      return 1;
    }

    return 0;
  }

  @override
  Future<List<User>> searchUser(String query) async{

    List<User> userList = [];

    Uri route = Uri.https(API_ROUTE,'/api/users/search');
    HttpClientRequest delReq = await userServer.getUrl(route);

    delReq.headers.add(HttpHeaders.authorizationHeader, _authModel.getToken().toString());


    HttpClientResponse result = await delReq.close();

    if (result.statusCode != HttpStatus.ok)
    {
      return userList;
    }

    dynamic decode  = jsonDecode(await result.transform(utf8.decoder).join());

    for (dynamic i in decode)
    {
      try
      {
        userList.add(User.fromJson(i));

      }
      catch(e)
      {
        continue;
      }

    }

    return userList;
  }

  @override
  Future<User?> getUser(int id) async{
    //build get request

    userServer.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/users/{${_authModel.getUserId()}}');

    try {
      HttpClientRequest request = await userServer.getUrl(route);
      request.headers.add(HttpHeaders.authorizationHeader, _authModel.getToken().toString());
      req = await request.close();
    }
    on SocketException catch (e)
    {
      return null;
    }
    if(req.statusCode != 200)
    {
      return null;
    }
    //decode json then
    try
    {
      dynamic result = jsonDecode(await req.transform(utf8.decoder).join());

      return User.fromJson(result);

    }
    on Exception catch(e)
    {
      return null;
    }

    //notify observers that i have fetched a user
    return null;
  }
  @override
  Future<int> updateUser(int id, User user)  async {
    //build get request

    userServer.connectionTimeout = const Duration(seconds: 4);

    HttpClientResponse req;

    //set request URI
    Uri route = Uri.https(API_ROUTE,'/api/users/{${_authModel.getUserId()}}');

    try {
      HttpClientRequest request = await userServer.putUrl(route);
      request.headers.add(HttpHeaders.authorizationHeader, _authModel.getToken().toString());
      request.write(jsonEncode(user));
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
    return 0;

    //decode json then



    //notify observers that i have fetched a user
    return 1;
  }

}

