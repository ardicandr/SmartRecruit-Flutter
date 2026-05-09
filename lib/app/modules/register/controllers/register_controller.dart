import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  var isTermsAgreed = false.obs; // State untuk checkbox

  void goToHome() => Get.offAllNamed(Routes.HOME); 

  // Fungsi baru untuk pindah ke halaman Login
  void goToLogin() => Get.toNamed(Routes.LOGIN); 
}