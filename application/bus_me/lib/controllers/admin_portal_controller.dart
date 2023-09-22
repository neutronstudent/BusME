import 'dart:async';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/auth_model.dart';


class AdminPortalController {
  BusMEAuth _authModel;


  late final _userManagementModel = BusMEUserManagement(_authModel);
  final _userController = StreamController<List<User>>();

  Stream<List<User>> get userStream => _userController.stream;
  
  AdminPortalController(this._authModel);
  Future<void> init() async {
    await search('');
  }

  Future<void> search(String query) async {
    final users = await _userManagementModel.searchUser(query);
    _userController.add(users);
  }

  void dispose() {
    _userController.close();
  }
}
