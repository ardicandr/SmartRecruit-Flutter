import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class StatusController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  var isLoading = true.obs;
  var myApplications = [].obs;
  var filterIndex = 0.obs;

  @override
  void onInit() {
    fetchMyApps();
    super.onInit();
  }

  void fetchMyApps() async {
    try {
      isLoading(true);
      Response response = await apiProvider.getMyApplications();
      if (response.statusCode == 200) {
        myApplications.assignAll(response.body);
      }
    } finally {
      isLoading(false);
    }
  }

  void changeFilter(int index) => filterIndex.value = index;

  void goToInterview() {
    Get.toNamed(Routes.INTERVIEW); 
  }

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATION);
  }
  
  void goToJobDetail(Map<String, dynamic> jobData) {
    Get.toNamed(Routes.DETAIL, arguments: jobData);
  }
}