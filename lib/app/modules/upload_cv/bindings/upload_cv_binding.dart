import 'package:get/get.dart';

import '../controllers/upload_cv_controller.dart';

class UploadCvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadCvController>(
      () => UploadCvController(),
    );
  }
}
