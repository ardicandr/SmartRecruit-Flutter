import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class StatusController extends GetxController {
  var filterIndex = 0.obs;

  void changeFilter(int index) => filterIndex.value = index;

  void goToInterview() {
    Get.toNamed(Routes.INTERVIEW); 
  }

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATION);
  }
  
  void goToJobDetail(Map<String, dynamic> jobData) {
    Get.toNamed(Routes.DETAIL, arguments: jobData);
  }
}