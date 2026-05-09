import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

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
      // 1. JIKA DARI ALUR LAMARAN
      Get.snackbar(
        "Lamaran Terkirim", 
        "Lamaran Anda berhasil dikirim ke database HRD!",
        backgroundColor: const Color(0xFF2563EB),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(Routes.HOME);
    } else {
      // 2. JIKA HANYA UPDATE PROFIL
      Get.back();
      Get.snackbar(
        "Profil Diperbarui", 
        "Data CV di profil Anda berhasil disimpan.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}