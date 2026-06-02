import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/upload_cv_controller.dart';

class UploadCvView extends GetView<UploadCvController> {
  const UploadCvView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        // Judul AppBar berubah dinamis sesuai mode
        title: Obx(() => Text(
          controller.isFromApplication.value ? "Konfirmasi Lamaran" : "Update CV Profil",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dokumen Pintar",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0B1C30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Gunakan AI kami untuk memproses profil Anda secara otomatis. Hemat waktu tanpa isi formulir panjang!",
                    style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 32),

                  // Status Header
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "DOKUMEN DARI PROFIL",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
                      ),
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: Colors.blue[600]),
                          const SizedBox(width: 4),
                          const Text(
                            "AI VERIFIED",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildFileCard(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => controller.pickAndScanCv(), 
                      child: const Text("Gunakan CV Lain / Scan CV", style: TextStyle(fontSize: 12, color: Colors.blue))
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 18, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      const Text(
                        "HASIL EKSTRAKSI AI",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tinjau Data Anda",
                    style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),

                  Obx(() => controller.isLoading.value 
                    ? const Center(child: CircularProgressIndicator()) 
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReviewField("Nama Lengkap", controller.fullNameC, Icons.person_outline),
                        _buildReviewField("Email", controller.emailC, Icons.mail_outline),
                        _buildReviewField("Nomor Telepon", controller.phoneC, Icons.phone_outlined),
                        _buildReviewField("Pengalaman Terakhir", controller.experienceC, Icons.work_outline),

                        const SizedBox(height: 24),
                        const Text("Keahlian Terdeteksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        Obx(() => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...controller.skills.map((skill) => _buildSkillTag(skill)),
                            _buildSkillTag("+ Tambah"),
                          ],
                        )),
                      ],
                    )),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Obx(() => controller.isLoading.value ? const SizedBox() : _buildBottomAction()),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildFileCard() {
    return Obx(() {
      String fileName = "Belum ada CV yang dipilih";
      if (controller.selectedImage.value != null) {
        fileName = controller.selectedImage.value!.name;
      } else if (controller.fullNameC.text.isNotEmpty) {
        fileName = "CV Profil (Tersimpan)";
      }
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue[200]!, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.description, color: Color(0xFF2563EB)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text("JPG/PNG", style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReviewField(String label, TextEditingController textController, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: textController,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTag(String label) {
    bool isAdd = label == "+ Tambah";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isAdd ? Colors.white : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: isAdd ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: isAdd ? Colors.grey : const Color(0xFF2563EB), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, size: 20, color: Color(0xFF2563EB)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TIPS AI", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                      Text("Periksa kembali data di atas sebelum menekan tombol konfirmasi.", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tombol Utama (Teks berubah sesuai Mode)
          Obx(() => ElevatedButton(
            onPressed: () => controller.handleFinalAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              shadowColor: Colors.blue.withOpacity(0.4)
            ),
            child: Text(
              controller.isFromApplication.value 
                  ? "Kirim Lamaran Sekarang" 
                  : "Simpan Perubahan Profil",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ))
        ],
      ),
    );
  }
}