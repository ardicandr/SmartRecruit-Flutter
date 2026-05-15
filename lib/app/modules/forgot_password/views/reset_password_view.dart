import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/forgot_password_controller.dart';

class ResetPasswordView extends GetView<ForgotPasswordController> {
  const ResetPasswordView({super.key});

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
              Text(
                "Kata Sandi Baru 🔐", 
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28, 
                  fontWeight: FontWeight.w800, 
                  color: AppColors.textDark
                )
              ),
              const SizedBox(height: 12),
              const Text(
                "Buatlah kata sandi yang baru agar Anda bisa kembali mengakses profil Anda.", 
                style: TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.5)
              ),
              const SizedBox(height: 40),
              
              _buildLabel("Kata Sandi Baru"),
              _buildTextField("Masukkan kata sandi baru", Icons.lock_outline),
              
              const SizedBox(height: 24),
              
              _buildLabel("Konfirmasi Kata Sandi"),
              _buildTextField("Ulangi kata sandi baru", Icons.history),
              
              const SizedBox(height: 40),
              
              _buildMainButton("Perbarui Kata Sandi", () => controller.updatePassword()),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8), 
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
  );

  Widget _buildTextField(String hint, IconData icon) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textGray),
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), 
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.4))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), 
          borderSide: const BorderSide(color: AppColors.primary, width: 2)
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
            offset: const Offset(0, 6)
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
            )
          ),
        ),
      ),
    );
  }
}