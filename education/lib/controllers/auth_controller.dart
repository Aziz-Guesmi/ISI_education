import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repository/auth_repo.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final _authRepo = Get.put(AuthRepo());

  Future<bool?> createUserController(UserModel user) async {
    bool? status = await _authRepo.SignUp(user.email!, user.password!);
    if (status == true) await _authRepo.createUser(user);
    return status;
  }

  Future<bool?> loginUserController(UserModel user) async {
    return _authRepo.SignIn(user.email!, user.password!);
  }

  Future<void> logoutController() async {
    _authRepo.logout();
  }

  getUserDetailsController() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _authRepo.getUserDetails(email);
    } else
      return null;
  }

  addSpecialiteToListController(String userId, String element) {
    _authRepo.addSpecialiteToList(userId, element);
  }

  Stream<List<dynamic>> getListSpecilityController(String userId) {
    return _authRepo.getListSpecility(userId);
  }


  Future<void> logout() async {
    try {
      await _authRepo.logout();
      // After signing out, you may want to navigate to the login screen or perform any other actions.
    } catch (e) {
      print("Error logging out: $e");
      rethrow; // You can handle the error as per your application's requirements.
    }
  }
   Future<void> deleteSpecialiteController(String userId, String speciality) async {
    try {
      await _authRepo.deleteSpecialite(userId, speciality);
    } catch (e) {
      print("Error deleting speciality: $e");
      rethrow; 
    }
  }
}
