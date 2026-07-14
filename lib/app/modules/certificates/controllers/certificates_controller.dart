import 'package:get/get.dart';

class CertificatesController extends GetxController {
  // Dummy data list sertifikat
  var certificates = [
    {
      "title": "Google Data Analytics Professional Certificate",
      "issuer": "Coursera (Google)",
      "date": "Jun 2023",
      "color": 0xFFE8EAF6, // Indigo
    },
    {
      "title": "Advanced React Design Patterns",
      "issuer": "Frontend Masters",
      "date": "Mar 2023",
      "color": 0xFFFCE4EC, // Rose
    },
    {
      "title": "AWS Certified Cloud Practitioner",
      "issuer": "Amazon Web Services",
      "date": "Des 2022",
      "color": 0xFFF1F5F9, // Slate
    },
  ].obs;

  void deleteCertificate(int index) {
    certificates.removeAt(index);
  }
}
