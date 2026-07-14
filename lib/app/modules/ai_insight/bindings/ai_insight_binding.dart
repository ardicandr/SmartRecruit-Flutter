import 'package:get/get.dart';

import '../controllers/ai_insight_controller.dart';

class AiInsightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiInsightController>(() => AiInsightController());
  }
}
