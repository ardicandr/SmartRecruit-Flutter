import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import 'package:smart_recruit/app/core/values/app_colors.dart';

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
    AppHelpers.showSnackbar(
      title: "Data Tersimpan",
      message: "Profil preferensi Anda berhasil diperbarui.",
    );
    Get.toNamed(Routes.UPLOAD_CV, arguments: {'isFromApplication': true});
  }
}