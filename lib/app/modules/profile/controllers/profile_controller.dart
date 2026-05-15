import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {

  var profileStrength = 0.85.obs;

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATION);
  }
}