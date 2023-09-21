

import 'dart:io';

import 'package:bus_me/models/user_model.dart';

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
}

class BusMEUserManagement extends UserManagementModel
{
  final AuthModel _authModel;

  HttpClient userServer = HttpClient(context: SecurityContext.defaultContext);

  BusMEUserManagement(this._authModel);

  @override
  Future<int> createUser(UserRegistration info, int userType) async {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<int> deleteUser(int id) async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<User>> searchUser(String query) async{
    // TODO: implement searchUser
    throw UnimplementedError();
  }

  @override
  Future<int> updateUser(int id, User user)  async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

}