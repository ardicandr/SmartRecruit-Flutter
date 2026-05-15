import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class AppSearchController extends GetxController { 
  var selectedFilter = "Remote".obs;
  void changeFilter(String value) => selectedFilter.value = value;

  void goToAiInsight() {
    Get.toNamed(Routes.AI_INSIGHT, arguments: 'search');
  }
}