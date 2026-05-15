import 'package:get/get.dart';

class AiInsightController extends GetxController {
  var origin = ''.obs;

  final Map<String, double> profileScores = {
    "Pengalaman": 85.0,
    "Skill Teknis": 92.0,
    "Sertifikasi": 95.0,
    "Pendidikan": 75.0,
    "Portofolio": 65.0,
  };

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      origin.value = Get.arguments.toString();
    }
  }

  void handleBack() {
    Get.back();
  }
}