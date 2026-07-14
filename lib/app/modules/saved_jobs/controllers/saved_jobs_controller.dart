import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class SavedJobsController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var savedJobs = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    try {
      isLoading.value = true;
      final response = await apiProvider.getBookmarks();
      if (response.statusCode == 200) {
        savedJobs.assignAll(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat lowongan tersimpan");
    } finally {
      isLoading.value = false;
    }
  }

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATION);
  }

  void removeBookmark(int index) async {
    final jobId = savedJobs[index]['job_id'];
    try {
      final response = await apiProvider.toggleBookmark(jobId, false);
      if (response.statusCode == 200) {
        savedJobs.removeAt(index);
        Get.snackbar(
          "Dihapus",
          "Lowongan berhasil dihapus dari simpanan",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus bookmark");
    }
  }
}
