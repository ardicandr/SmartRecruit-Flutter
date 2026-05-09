import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class AssessmentController extends GetxController {
  var currentQuestion = 0.obs;
  var answers = <int>[].obs;

  final List<String> questions = [
    "Saya merasa nyaman saat harus memimpin diskusi dalam tim.",
    "Saya cenderung merencanakan segala sesuatu secara mendetail.",
    "Saya lebih suka bekerja dalam lingkungan yang dinamis dan cepat berubah.",
    "Saya mudah berempati terhadap permasalahan rekan kerja.",
    "Saya tetap tenang meskipun berada di bawah tekanan tenggat waktu.",
  ];

  void nextQuestion(int score) {
    answers.add(score);
    
    if (currentQuestion.value < questions.length - 1) {
      currentQuestion.value++;
    } else {
      submitAssessment();
    }
  }

  void submitAssessment() {
    // Menggunakan bahasa yang lebih user-friendly dan profesional
    Get.snackbar(
      "Data Tersimpan", 
      "Profil preferensi Anda berhasil diperbarui. Silakan lengkapi berkas lamaran Anda.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2170E4),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
    
    // Pindah ke halaman Upload CV
    Get.toNamed(Routes.UPLOAD_CV, arguments: {'isFromApplication': true});
  }
}