import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class InterviewController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  var isLoading = true.obs;
  var interviewList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchInterviews();
    super.onInit();
  }

  void fetchInterviews() async {
    try {
      isLoading(true);
      Response response = await apiProvider.getMyApplications();
      if (response.statusCode == 200) {
        List data = response.body;
        // Filter only those that are scheduled for interview
        var filtered = data.where((app) => app['status'] == 'Interview' && app['interview_date'] != null).toList();
        
        List<Map<String, dynamic>> formattedList = [];
        for (var f in filtered) {
          formattedList.add({
            "id": f['id'],
            "company": f['company_name'] ?? f['company'],
            "company_logo": f['company_logo'],
            "role": f['job_title'] ?? f['title'],
            "isOnline": f['interview_type'] == 'Online',
            "dateRaw": f['interview_date'],
            "type": f['interview_type'],
            "location": f['interview_location'] ?? '-',
            "rawData": f,
          });
        }
        interviewList.assignAll(formattedList);
      }
    } finally {
      isLoading(false);
    }
  }

  void goToDetail(Map<String, dynamic> data) {
    Get.toNamed(Routes.INTERVIEW_DETAIL, arguments: data);
  }
}