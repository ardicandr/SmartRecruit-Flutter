import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/models/job_model.dart';

class DetailController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  
  var isBookmarked = false.obs;
  var jobId = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args is JobModel) {
        jobId = args.id ?? 0;
        // isBookmarked.value = false;
      } else if (args is Map) {
        jobId = args['id'] ?? args['job_id'] ?? 0;
        isBookmarked.value = args['is_bookmarked'] ?? false;
      }
    }
  }

  void toggleBookmark() async {
    if (jobId == 0) return;
    
    // Optimistic UI update
    isBookmarked.value = !isBookmarked.value;
    bool newStatus = isBookmarked.value;
    
    try {
      final response = await apiProvider.toggleBookmark(jobId, newStatus);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          newStatus ? "Lowongan Tersimpan" : "Dihapus",
          newStatus ? "Berhasil disimpan ke Bookmark." : "Dihapus dari Bookmark.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Revert on failure
        isBookmarked.value = !newStatus;
        Get.snackbar("Error", "Gagal menyimpan bookmark");
      }
    } catch (e) {
      isBookmarked.value = !newStatus;
      Get.snackbar("Error", "Terjadi kesalahan jaringan");
    }
  }

  void applyNow() => Get.toNamed(Routes.UPLOAD_CV, arguments: {'isFromApplication': true, 'jobId': jobId});
}