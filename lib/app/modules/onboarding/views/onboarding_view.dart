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
            // 1. Header (Fixed)
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

            // 2. Sliding Area (Gambar & Teks)
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemCount: controller.onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Illustration Box
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(controller.onboardingData[index]['image']!),
                              fit: BoxFit.cover
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 10))
                            ]
                          ),
                        ),
                      ),
                      
                      // Content Area (White Box)
                      Container(
                        padding: EdgeInsets.fromLTRB(32, 40, 32, 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.vertical(top: Radius.circular(32))
                        ),
                        child: Column(
                          children: [
                            Text(
                              controller.onboardingData[index]['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 16),
                            Text(
                              controller.onboardingData[index]['desc']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textMuted, fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 3. Footer Area (Indikator & Tombol)
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  // Dots Indicator
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 8),
                        height: 8,
                        width: controller.currentPage.value == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index ? AppColors.primary : Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 32),
                  
                  // Main Button
                  ElevatedButton(
                    onPressed: () => controller.goToLogin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.3)
                    ),
                    child: Text("Mulai Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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