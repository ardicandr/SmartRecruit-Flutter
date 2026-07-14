import 'package:get/get.dart';

import '../controllers/add_certificate_controller.dart';

class AddCertificateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCertificateController>(() => AddCertificateController());
  }
}
