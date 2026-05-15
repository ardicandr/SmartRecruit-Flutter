import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:SmartRecruit/app/core/values/app_colors.dart';
import '../../../routes/app_routes.dart';

class SavedJobsController extends GetxController {
  var savedJobs = [
    {
      "title": "Mobile UI/UX Designer",
      "company": "Blibli.com",
      "location": "Jakarta Barat",
      "salary": "Rp 14 - 18 Juta",
      "match": "98%",
    },
    {
      "title": "React Native Developer",
      "company": "DANA Indonesia",
      "location": "Jakarta Pusat",
      "salary": "Rp 18 - 25 Juta",
      "match": "92%",
    }
  ].obs;

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATION);
  }

  void removeBookmark(int index) {
    savedJobs.removeAt(index);
    AppHelpers.showSnackbar(
      title: "Dihapus",
      message: "Lowongan berhasil dihapus dari simpanan",
    );
  }
}