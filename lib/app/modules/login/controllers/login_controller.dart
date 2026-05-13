import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void goToRegister() => Get.toNamed(Routes.REGISTER);

  void login() {
    Get.offAllNamed(Routes.HOME);
  }
}
