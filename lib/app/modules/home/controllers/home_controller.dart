import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/models/job_model.dart';

class HomeController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final storage = const FlutterSecureStorage();
  
  var tabIndex = 0.obs;
  var userName = "User".obs;
  var profileImageUrl = "".obs;
  var localImagePath = "".obs;
  var showGreeting = true.obs; // Greeting tampil 5 detik
  Timer? _greetingTimer;

  File? get localImageFile => localImagePath.value.isNotEmpty ? File(localImagePath.value) : null;

  // State untuk Data Job
  var isLoading = true.obs;
  var latestJobs = <JobModel>[].obs;
  var specialJobs = <JobModel>[].obs;
  var hasCvOrSkills = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchJobs();
    // Sembunyikan greeting setelah 5 detik
    _greetingTimer = Timer(const Duration(seconds: 5), () {
      showGreeting.value = false;
    });
  }

  @override
  void onClose() {
    _greetingTimer?.cancel();
    super.onClose();
  }

  void fetchJobs() async {
    try {
      isLoading(true);
      Response response = await apiProvider.getJobs();
      
      if (response.statusCode == 200 && response.body != null) {
        List data = response.body;
        List<JobModel> loadedJobs = data.map((e) => JobModel.fromJson(e)).toList();
        
        latestJobs.assignAll(loadedJobs);
        specialJobs.assignAll(loadedJobs.take(3).toList());
      } else {
        latestJobs.clear();
        specialJobs.clear();
        Get.snackbar("Gagal Memuat", "Status: \${response.statusCode}. Pesan: \${response.bodyString}");
      }
    } catch (e) {
      Get.snackbar("Error Koneksi", "Gagal fetchJobs: \$e");
    } finally {
      isLoading(false);
    }
  }

  void loadUserData() async {
    // Baca dari local storage dulu (cepat)
    String? storedName = await storage.read(key: 'user_name');
    String? storedImageUrl = await storage.read(key: 'user_image_url');
    String? storedLocalImage = await storage.read(key: 'user_local_image');

    if (storedName != null) userName.value = storedName;
    if (storedImageUrl != null) profileImageUrl.value = storedImageUrl;
    if (storedLocalImage != null) localImagePath.value = storedLocalImage;

    // Fetch data terbaru dari backend
    try {
      final response = await apiProvider.get("/auth/profile");
      if (response.statusCode == 200) {
        final userData = response.body['user'];
        if (userData != null) {
          userName.value = userData['username'] ?? userData['full_name'] ?? userName.value;
          await storage.write(key: 'user_name', value: userName.value);

          if (userData['image'] != null && userData['image'].toString().isNotEmpty) {
            profileImageUrl.value = "${ApiProvider.hostUrl}${userData['image']}";
            localImagePath.value = ""; // reset local jika ada URL baru
            await storage.write(key: 'user_image_url', value: profileImageUrl.value);
            await storage.delete(key: 'user_local_image');
          }

          // Cek apakah user punya CV atau Skill
          bool hasCv = userData['cv_url'] != null || userData['parsed_cv'] != null;
          bool hasSkill = userData['skills_tags'] != null && userData['skills_tags'].toString().trim().isNotEmpty;
          hasCvOrSkills.value = hasCv || hasSkill;
        }
      }
    } catch (e) {
      // Gagal fetch, gunakan data cached
    }
  }

  void goToNotifications() => Get.toNamed(Routes.NOTIFICATION);
  void changeTabIndex(int index) => tabIndex.value = index;
  void goToSearch() => Get.toNamed(Routes.SEARCH);
  
  void goToDetail(JobModel job) {
    Get.toNamed(Routes.DETAIL, arguments: job);
  }
}