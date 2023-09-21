

import 'package:bus_me/models/user_model.dart';

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