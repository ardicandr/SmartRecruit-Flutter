import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:smart_recruit/app/core/values/app_colors.dart';

class DetailController extends GetxController {
  // State untuk status bookmark
  var isBookmarked = false.obs;

  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;
    AppHelpers.showSnackbar(
      title: isBookmarked.value ? "Lowongan Tersimpan" : "Dihapus",
      message: isBookmarked.value ? "Berhasil disimpan ke Bookmark." : "Dihapus dari Bookmark.",
    );
  }

  void applyNow() => Get.toNamed(Routes.ASSESSMENT);
}