import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;
  Timer? timer;

  final int initialPage = 999;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Cari Kerja Jadi Lebih Pintar",
      "desc":
          "Teknologi AI kami menganalisis CV Anda dan mencocokkannya secara otomatis.",
      "image":
          "https://images.unsplash.com/photo-1512428559087-560fa5ceab42?q=80&w=500&auto=format&fit=crop",
    },
    {
      "title": "Pantau Status Real-Time",
      "desc":
          "Dapatkan notifikasi langsung saat lamaran Anda ditinjau atau diproses HRD.",
      "image":
          "https://images.unsplash.com/photo-1551434678-e076c223a692?w=500&auto=format&fit=crop&q=60",
    },
    {
      "title": "Bangun Portofolio Profesional",
      "desc":
          "Kelola sertifikat dan pengalaman Anda untuk menarik perhatian perusahaan ternama.",
      "image":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500&auto=format&fit=crop&q=60",
    },
  ];

  @override
  void onInit() {
    pageController = PageController(initialPage: initialPage);

    currentPage.value = 0;

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void goToLogin() => Get.toNamed(Routes.REGISTER);
}
