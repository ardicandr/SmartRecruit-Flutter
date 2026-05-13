import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class InterviewController extends GetxController {
  // Data dummy daftar panggilan wawancara
  final List<Map<String, dynamic>> interviewList = [
    {
      "id": 1,
      "company": "TechNova Solutions",
      "role": "Senior UI/UX Designer",
      "isOnline": true,
      "date": "Jumat, 20 Oktober 2023",
      "time": "14:00 - 15:00 WIB",
      "meetingId": "821 3456 7890",
      "passcode": "TECH2023",
      "link": "https://zoom.us/j/82134567890",
    },
    {
      "id": 2,
      "company": "GoCreative Agency",
      "role": "Frontend Developer",
      "isOnline": false,
      "date": "Senin, 23 Oktober 2023",
      "time": "10:00 - 12:00 WIB",
      "location": "GoCreative Tower, Lantai 5",
      "address": "Jl. Sudirman No. 10, Jakarta Pusat",
      "pic": "Bpk. Andi (HRD) - 081233445566",
    }
  ];

  void goToDetail(Map<String, dynamic> data) {
    Get.toNamed(Routes.INTERVIEW_DETAIL, arguments: data);
  }
}