import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:SmartRecruit/app/core/values/app_colors.dart';

class UploadCvController extends GetxController {
  var isFromApplication = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      isFromApplication.value = Get.arguments['isFromApplication'] ?? false;
    }
  }

  void handleFinalAction() {
    if (isFromApplication.value) {
      Get.offAllNamed(Routes.HOME);
      AppHelpers.showSnackbar(
        title: "Lamaran Terkirim",
        message: "Lamaran Anda telah diterima oleh HRD.",
      );
    } else {
      Get.back();
      AppHelpers.showSnackbar(
        title: "Profil Diperbarui",
        message: "CV Anda telah berhasil diupdate.",
      );
    }
  }
}