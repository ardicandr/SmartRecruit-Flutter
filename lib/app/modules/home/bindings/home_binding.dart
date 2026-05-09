import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../status/controllers/status_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<StatusController>(() => StatusController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}