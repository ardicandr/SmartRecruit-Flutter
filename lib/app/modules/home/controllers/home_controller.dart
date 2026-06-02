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
  
  // State untuk Data Job
  var isLoading = true.obs;
  var latestJobs = <JobModel>[].obs;
  var specialJobs = <JobModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchJobs();
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
        print("Data kosong atau status code bukan 200");
      }
    } catch (e) {
      print("Error fetchJobs: $e");
    } finally {
      isLoading(false);
    }
  }

  void loadUserData() async {
    String? storedName = await storage.read(key: 'user_name');
    if (storedName != null) {
      userName.value = storedName;
    }
  }

  void goToNotifications() => Get.toNamed(Routes.NOTIFICATION);
  void changeTabIndex(int index) => tabIndex.value = index;
  void goToSearch() => Get.toNamed(Routes.SEARCH);
  
  void goToDetail(JobModel job) {
    Get.toNamed(Routes.DETAIL, arguments: job);
  }
}