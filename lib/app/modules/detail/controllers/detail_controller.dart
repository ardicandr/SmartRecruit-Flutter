import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/models/job_model.dart';
import '../../saved_jobs/controllers/saved_jobs_controller.dart';
import '../../home/controllers/home_controller.dart';

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
        isBookmarked.value = args.isBookmarked ?? false;
      } else if (args is Map) {
        jobId = args['id'] ?? args['job_id'] ?? 0;
        isBookmarked.value = args['is_bookmarked'] ?? false;
      }
    }

    // Fetch AI Match Score when view is opened
    fetchMatchScore();
  }

  // --- AI MATCH SCORE DYNAMIC ---
  var aiMatchScore = 0.0.obs;
  var aiMatchReason = "Menghitung kecocokan profil Anda...".obs;
  var isMatchLoading = true.obs;

  void fetchMatchScore() async {
    if (jobId == 0) return;

    try {
      isMatchLoading.value = true;
      final response = await apiProvider.getJobMatchScore(jobId);

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['overall_score'] != null) {
          aiMatchScore.value = (data['overall_score'] as num).toDouble();
        }
        if (data['reason'] != null) {
          aiMatchReason.value = data['reason'];
        }
      }
    } catch (e) {
      print("Gagal mengambil AI Match Score: $e");
      aiMatchReason.value = "Gagal memuat skor kecocokan AI.";
    } finally {
      isMatchLoading.value = false;
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
          newStatus
              ? "Berhasil disimpan ke Bookmark."
              : "Dihapus dari Bookmark.",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh SavedJobsController jika sudah aktif
        if (Get.isRegistered<SavedJobsController>()) {
          Get.find<SavedJobsController>().fetchBookmarks();
        }

        // Sinkronkan state ke HomeController agar ikon di home ikut berubah
        if (Get.isRegistered<HomeController>()) {
          final homeCtrl = Get.find<HomeController>();
          final int idxLatest = homeCtrl.latestJobs.indexWhere(
            (j) => j.id == jobId,
          );
          if (idxLatest != -1) {
            homeCtrl.latestJobs[idxLatest].isBookmarked = newStatus;
            homeCtrl.latestJobs.refresh();
          }
          final int idxSpecial = homeCtrl.specialJobs.indexWhere(
            (j) => j.id == jobId,
          );
          if (idxSpecial != -1) {
            homeCtrl.specialJobs[idxSpecial].isBookmarked = newStatus;
            homeCtrl.specialJobs.refresh();
          }
        }
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

  void applyNow() => Get.toNamed(
    Routes.UPLOAD_CV,
    arguments: {'isFromApplication': true, 'jobId': jobId},
  );
}
