import 'dart:async';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/auth_model.dart';


class AdminPortalController {
  final _authModel = BusMEAuth();

  late final _userManagementModel = BusMEUserManagement(_authModel);
  final _userController = StreamController<List<User>>();

  Stream<List<User>> get userStream => _userController.stream;

  void init() {
    search('');
  }

  void search(String query) async {
    final users = await _userManagementModel.searchUser(query);
    _userController.add(users);
  }

  void dispose() {
    _userController.close();
  }
}
