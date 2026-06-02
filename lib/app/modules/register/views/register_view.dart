import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildBrandHeader(),
              const SizedBox(height: 40),
              _buildWelcomeText(),
              const SizedBox(height: 32),

              _buildLabel("Nama Lengkap"),
              _buildTextField(
                hint: "John Doe", 
                icon: Icons.person_outline,
                controller: controller.nameC,
              ),
              const SizedBox(height: 24),

              _buildLabel("Alamat Email"),
              _buildTextField(
                hint: "nama@email.com", 
                icon: Icons.email_outlined,
                controller: controller.emailC,
              ),
              const SizedBox(height: 12),
              
              _buildOTPSection(), 
              const SizedBox(height: 24),

              _buildLabel("Kata Sandi"),
              Obx(() => _buildTextField(
                hint: "••••••••",
                icon: Icons.lock_outline,
                controller: controller.passC,
                isPassword: controller.isPasswordHidden.value,
                suffixIcon: controller.isPasswordHidden.value 
                    ? Icons.visibility_outlined 
                    : Icons.visibility_off_outlined,
                onSuffixIconPressed: () => controller.togglePasswordVisibility(),
              )),
              const SizedBox(height: 24),

              _buildLabel("Konfirmasi Kata Sandi"),
              Obx(() => _buildTextField(
                hint: "••••••••",
                icon: Icons.history, 
                controller: controller.confirmPassC,
                isPassword: controller.isPasswordHidden.value,
              )),
              const SizedBox(height: 24),

              // TOMBOL DAFTAR
              Obx(() => controller.isLoading.value 
                ? const Center(child: CircularProgressIndicator())
                : _buildMainButton("Buat Akun", Icons.arrow_forward, () {
                    controller.register();
                  })
              ),

              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 24),

              _buildSocialButton(
                "Daftar dengan Google", 
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlh1Kyfo9hJplmkiOKcHD9XcpUvlJaZrh5ZA&static/img/google_signin_buttons/web/2x/btn_google_signin_dark_normal_web.png"
              ),

              const SizedBox(height: 48),
              _buildLoginRedirect(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helper ---

  Widget _buildBrandHeader() {
    return Text(
      "SmartRecruit",
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Center(
      child: Column(
        children: [
          Text(
            "Buat Akun Baru",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Daftar sekarang untuk memulai perjalanan karir profesional Anda bersama AI.",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textGray,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool isPassword = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
        suffixIcon: suffixIcon != null ? IconButton(
          icon: Icon(suffixIcon, color: AppColors.textGray, size: 20),
          onPressed: onSuffixIconPressed,
        ) : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildOTPSection() {
    return ElevatedButton(
      onPressed: () => Get.snackbar("OTP", "Fitur OTP dilewati sementara"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDCE9FF),
        elevation: 0,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        "Kirim Kode OTP",
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMainButton(String text, IconData icon, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF0058BE),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0058BE).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("ATAU", style: GoogleFonts.plusJakartaSans(color: AppColors.textGray, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildSocialButton(String text, String logoUrl) {
    return InkWell(
      onTap: () => Get.snackbar("Google", "Fitur ini akan segera aktif"),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(logoUrl, width: 24, height: 24, 
              errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, size: 30)),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Center(
      child: GestureDetector(
        onTap: () => controller.goToLogin(), 
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(color: AppColors.textGray, fontSize: 14),
            children: [
              const TextSpan(text: "Sudah memiliki akun? "),
              TextSpan(text: "Masuk di sini", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}