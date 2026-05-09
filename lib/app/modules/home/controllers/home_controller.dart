import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs;

  // Data Dummy Rekomendasi (Horizontal)
  final List<Map<String, dynamic>> specialJobs = [
    {
      "title": "Senior Product Designer",
      "company": "Gojek Indonesia",
      "location": "Jakarta",
      "salary": "15jt - 25jt",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Gojek_logo_2019.svg/1200px-Gojek_logo_2019.svg.png"
    },
    {
      "title": "Lead Front End",
      "company": "Traveloka",
      "location": "Tangerang",
      "salary": "20jt - 35jt",
      "logo": "https://upload.wikimedia.org/wikipedia/id/thumb/e/e7/Traveloka_logo.png/800px-Traveloka_logo.png"
    }
  ];

  // Data Dummy Lowongan Terbaru (Vertical)
  final List<Map<String, dynamic>> latestJobs = [
    {
      "title": "Mobile UI/UX",
      "company": "Blibli.com",
      "location": "Jakarta Barat",
      "salary": "Rp 14 - 18 Juta",
      "match": "98%",
      "tags": ["Figma", "Design System", "Remote"],
      "posted": "2 jam yang lalu"
    },
    {
      "title": "React Native",
      "company": "DANA Indonesia",
      "location": "Jakarta Pusat",
      "salary": "Rp 18 - 25 Juta",
      "match": "92%",
      "tags": ["TypeScript", "Redux", "API"],
      "posted": "5 jam yang lalu"
    },
    {
      "title": "Backend Architect",
      "company": "Bukalapak",
      "location": "Jakarta Selatan",
      "salary": "Rp 25 - 40 Juta",
      "match": "85%",
      "tags": ["Go", "Kubernetes", "Redis"],
      "posted": "1 hari yang lalu"
    }
  ];

  void changeTabIndex(int index) => tabIndex.value = index;
  void goToSearch() {
    Get.toNamed(Routes.SEARCH);
  }
  void goToDetail(Map<String, dynamic> jobData) {
    Get.toNamed(Routes.DETAIL, arguments: jobData);
  }
}