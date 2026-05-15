import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/forgot_password_controller.dart';

class VerifyOtpView extends GetView<ForgotPasswordController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(), 
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black)
        ),
        backgroundColor: Colors.white, 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Verifikasi Email ✉️",
                style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)
              ),
              const SizedBox(height: 12),
              const Text(
                "Masukkan 6 digit kode yang baru saja kami kirimkan ke email Anda.", 
                style: TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.5)
              ),
              const SizedBox(height: 40),
              
              // GRID INPUT OTP
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOtpBox(context)),
                ),
              ),
              
              const SizedBox(height: 40),
              _buildMainButton("Verifikasi Kode", () => controller.verifyOtp()),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textGray, fontSize: 14),
                    children: [
                      const TextSpan(text: "Belum menerima kode? "),
                      TextSpan(
                        text: "Kirim Ulang", 
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Kotak OTP dengan Logika Auto-Focus
  Widget _buildOtpBox(BuildContext context) {
    return Container(
      width: 45,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: Center(
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            // LOGIKA PINDAH KE KANAN (Isi)
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
            // LOGIKA PINDAH KE KIRI (Hapus)
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1), // Batasi 1 angka per kotak
            FilteringTextInputFormatter.digitsOnly, // Hanya boleh angka
          ],
          decoration: const InputDecoration(
            border: InputBorder.none, 
            counterText: ""
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onTap) {
    return Container(
      width: double.infinity, 
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), 
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(text, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
            )
          ),
        ),
      ),
    );
  }
}