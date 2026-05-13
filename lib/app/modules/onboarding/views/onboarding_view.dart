import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SmartRecruit", style: GoogleFonts.plusJakartaSans(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                  TextButton(onPressed: () => controller.goToLogin(), child: Text("Lewati", style: TextStyle(color: AppColors.primary))),
                ],
              ),
            ),

            // Sliding Area (Gambar & Teks)
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  // Gunakan modulo agar currentPage selalu 0, 1, atau 2
                  controller.currentPage.value = index % controller.onboardingData.length;
                },
                itemBuilder: (context, index) {
                  // Ambil data menggunakan modulo
                  int realIndex = index % controller.onboardingData.length;
                  var data = controller.onboardingData[realIndex];

                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(data['image']!),
                              fit: BoxFit.cover
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                            ]
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.vertical(top: Radius.circular(32))
                        ),
                        child: Column(
                          children: [
                            Text(
                              data['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data['desc']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Footer Area (Indikator & Tombol)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: controller.currentPage.value == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index ? AppColors.primary : Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => controller.goToLogin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.3)
                    ),
                    child: const Text("Mulai Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}