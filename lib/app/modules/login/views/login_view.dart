import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text("SmartRecruit",
                  style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20)),
              const SizedBox(height: 24),
              Text("Selamat Datang\nKembali!",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      height: 1.2)),
              const SizedBox(height: 12),
              Text(
                  "Masuk untuk mengelola lamaran dan temukan peluang karir impian Anda.",
                  style: TextStyle(
                      color: AppColors.textGray, fontSize: 14, height: 1.5)),
              const SizedBox(height: 24),

              // EMAIL FORM
              _buildLabel("Alamat Email"),
              _buildTextField(hint: "nama@email.com", icon: Icons.email_outlined),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Kata Sandi"),
                  GestureDetector(
                    onTap: () => Get.snackbar(
                        "Fitur", "Reset password akan segera tersedia"),
                    child: Text("Lupa kata sandi?",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),

              Obx(() => _buildTextField(
                    hint: "........",
                    icon: Icons.lock_outline,
                    isPassword: controller.isPasswordHidden.value,
                    suffixIcon: controller.isPasswordHidden.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixIconPressed: () =>
                        controller.togglePasswordVisibility(),
                  )),

              const SizedBox(height: 24),

              // MAIN BUTTON
              GestureDetector(
                onTap: () => controller.login(),
                child: _buildMainButton("Masuk Sekarang", Icons.arrow_forward),
              ),

              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Get.snackbar(
                    "Google", "Google Sign-In akan segera aktif"),
                child: _buildSocialButton(
                  "Lanjutkan dengan Google",
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlh1Kyfo9hJplmkiOKcHD9XcpUvlJaZrh5ZA&static/img/google_signin_buttons/web/2x/btn_google_signin_dark_normal_web.png",
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => controller.goToRegister(),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: AppColors.textGray, fontSize: 14),
                      children: [
                        const TextSpan(text: "Belum punya akun? "),
                        TextSpan(
                            text: "Daftar di sini",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, String logoUrl) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withOpacity(0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            logoUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.g_mobiledata, size: 30),
          ),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  // Widget TextField
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: AppColors.textGray, size: 20),
                onPressed: onSuffixIconPressed,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.outline.withOpacity(0.5))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)));

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("ATAU",
                style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5))),
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildMainButton(String text, IconData icon) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF3B82F6),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}