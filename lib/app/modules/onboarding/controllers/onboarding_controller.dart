import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;
  Timer? timer;

  // Data untuk 3 slide
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Cari Kerja Jadi Lebih Pintar",
      "desc": "Teknologi AI kami menganalisis CV Anda dan mencocokkannya secara otomatis.",
      "image": "https://lh3.googleusercontent.com/aida/ADBb0ughCoIyKy2zQmeE07EqjIkuoUXh1bo6_zBjs8dYQb6kkWANqdqavjohkFSQ2OO0bd7FlbZAa4EOhNuFfoGWcnM1UiHtlUDWQM7ETaQ5B4OYsH3jw9hbmFVGmDoyI0oyTpi2qJIr-LFKnW2NcSwyzeqylJANjgVSsqfvVbMtRgftGJh3bYjBjpGsUTzLuTHFTgVa825VOHCOpL9jmj9WNzlvt18uYKCD6zSoklQZ-XfLlD_fAcPzMAE8JZ99IJY_YIKNb-IRLiwJ5g"
    },
    {
      "title": "Pantau Status Real-Time",
      "desc": "Dapatkan notifikasi langsung saat lamaran Anda ditinjau atau diproses HRD.",
      "image": "https://images.unsplash.com/photo-1551434678-e076c223a692?w=500&auto=format&fit=crop&q=60" // Ganti link gambar jika perlu
    },
    {
      "title": "Bangun Portofolio Profesional",
      "desc": "Kelola sertifikat dan pengalaman Anda untuk menarik perhatian perusahaan ternama.",
      "image": "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500&auto=format&fit=crop&q=60"
    },
  ];

  @override
  void onInit() {
    pageController = PageController();
    // Jalankan timer otomatis setiap 3 detik
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (currentPage.value < onboardingData.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 500),
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