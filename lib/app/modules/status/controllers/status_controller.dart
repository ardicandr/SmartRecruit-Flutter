import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class StatusController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  var isLoading = true.obs;
  var myApplications = [].obs;
  var filterIndex = 0.obs;

  List<dynamic> get filteredApplications {
    if (filterIndex.value == 1) {
      // Aktif
      return myApplications
          .where(
            (app) =>
                app['status'] != 'Accepted' &&
                app['status'] != 'Rejected' &&
                app['status'] != 'Closed',
          )
          .toList();
    } else if (filterIndex.value == 2) {
      // Selesai
      return myApplications
          .where(
            (app) =>
                app['status'] == 'Accepted' ||
                app['status'] == 'Rejected' ||
                app['status'] == 'Closed',
          )
          .toList();
    }
    return myApplications;
  }

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
