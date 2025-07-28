import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.user);
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register(
      String email, String password, String displayName) async {
    try {
      await _authService.register(email, password, displayName);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
