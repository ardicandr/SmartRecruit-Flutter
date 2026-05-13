import 'package:get/get.dart';

import '../controllers/saved_jobs_controller.dart';

class SavedJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedJobsController>(
      () => SavedJobsController(),
    );
  }
}
