import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/assessment_controller.dart';

class AssessmentView extends GetView<AssessmentController> {
  const AssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
        title: Text(
          "Survey Profiling",
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Progress Bar
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pertanyaan ${controller.currentQuestion.value + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2170E4),
                        ),
                      ),
                      Text(
                        "${controller.currentQuestion.value + 1}/${controller.questions.length}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value:
                          (controller.currentQuestion.value + 1) /
                          controller.questions.length,
                      minHeight: 8,
                      backgroundColor: Colors.blue[50],
                      color: const Color(0xFF2170E4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 2. Pertanyaan
            Expanded(
              child: Center(
                child: Obx(
                  () => Text(
                    controller.questions[controller.currentQuestion.value],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0B1C30),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            // 3. Instruksi Singkat
            const Center(
              child: Text(
                "Seberapa setuju Anda dengan pernyataan di atas?",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),

            // 4. Likert Scale Buttons (1-5)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => _buildChoiceButton(index + 1),
              ),
            ),

            const SizedBox(height: 20),

            // Label Keterangan
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sangat Tidak\nSetuju",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  "Sangat\nSetuju",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol angka 1-5
  Widget _buildChoiceButton(int score) {
    return InkWell(
      onTap: () => controller.nextQuestion(score),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "$score",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2170E4),
            ),
          ),
        ),
      ),
    );
  }
}
