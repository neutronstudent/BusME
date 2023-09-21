
import 'dart:developer';

import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';

class LoginController implements Observer
{

  final AuthModel _authModel;

  LoginController(this._authModel);

  @override
  Future<void> notify(ObsSignal notification) async {

    if (notification.type == "login")
    {

      await _authModel.loginUser(notification.parameters["username"], notification.parameters["password"]);
    }
  }

  Future<bool> createAccount(String username, String password) async {
    return await _authModel.createAccount(username, password);
  }
}


