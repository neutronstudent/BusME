import '../models/auth_model.dart';
import '../models/user_management.dart';
import '../models/user_model.dart';

class UserDetailsController {

  //RegExp for email and phone validation
  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
  final RegExp phoneRegex = RegExp(r"^[0-9]+$");

  final BusMEUserManagement userManagement;

  UserDetailsController(AuthModel authModel) : userManagement = BusMEUserManagement(authModel);

  bool isValidEmail(String email) => emailRegex.hasMatch(email);
  bool isValidPhone(String phone) => phoneRegex.hasMatch(phone);

  Future<int> updateUser(User user) {
    return userManagement.updateUser(user.id, user);
  }

  Future<int> deleteUser(int userId) {
    return userManagement.deleteUser(userId);
  }
}
