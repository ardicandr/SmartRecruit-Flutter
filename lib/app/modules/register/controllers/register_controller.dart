import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void goToHome() => Get.offAllNamed(Routes.HOME); 
  void goToLogin() => Get.toNamed(Routes.LOGIN); 
}