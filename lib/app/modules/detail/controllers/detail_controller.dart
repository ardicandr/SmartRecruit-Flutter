import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class DetailController extends GetxController {
  
  void applyNow() {
    Get.toNamed(Routes.ASSESSMENT);
  }
}