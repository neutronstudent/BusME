import 'dart:async';
import 'package:bus_me/models/user_model.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/auth_model.dart';

class AdminPortalController {
  static final AdminPortalController _instance = AdminPortalController._internal(BusMEAuth());

  BusMEAuth _authModel;

  late final _userManagementModel = BusMEUserManagement(_authModel);
  final _userController = StreamController<List<User>>();

  Stream<List<User>> get userStream => _userController.stream;

  factory AdminPortalController() {
    return _instance;
  }

  AdminPortalController._internal(this._authModel);

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
