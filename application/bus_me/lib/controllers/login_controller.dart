import 'package:bus_me/models/auth_model.dart';
import 'package:bus_me/observable.dart';
import 'package:bus_me/models/user_management.dart';
import 'package:bus_me/models/user_model.dart';

class LoginController implements Observer {
  static final LoginController _instance = LoginController._internal(BusMEAuth(), BusMEUserModel());

  final AuthModel _authModel;
  final BusMEUserModel _busMEUserManagement;

  factory LoginController() {
    return _instance;
  }

  LoginController._internal(this._authModel, this._busMEUserManagement);

  @override
  Future<void> notify(ObsSignal notification) async {
    if (notification.type == "login") {
      await _authModel.loginUser(notification.parameters["username"], notification.parameters["password"]);
    }
  }

  Future<bool> createAccount(String username, String password, String name, String email, String phone) async {
    bool created = false;

    UserDetails userDetails = UserDetails(name, email, phone);
    UserRegistration userRegistration = UserRegistration(username, password, userDetails);

    if (await _busMEUserManagement.registerUser(userRegistration) == 0) {
      created = true;
    }

    return created;
  }
}
