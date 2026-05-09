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
              // Logo Header
              Text(
                "SmartRecruit",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              
              // Title Section
              Center(
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
              ),
              const SizedBox(height: 32),

              // Social Login Button
              _buildSocialButton("Lanjutkan dengan Google"),

              const SizedBox(height: 32),
              _buildDivider(),
              const SizedBox(height: 32),

              // Form Fields
              _buildLabel("Nama Lengkap"),
              _buildTextField(hint: "John Doe", icon: Icons.person_outline),
              const SizedBox(height: 24),

              _buildLabel("Alamat Email"),
              _buildTextField(hint: "nama@email.com", icon: Icons.email_outlined),
              const SizedBox(height: 12),
              // Tombol OTP (Biru Muda)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCE9FF), // Light blue OTP
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Kirim Kode OTP",
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel("Nomor Telepon"),
              _buildTextField(hint: "+62 812 ...", icon: Icons.phone_outlined),
              const SizedBox(height: 24),

              _buildLabel("Kata Sandi"),
              _buildTextField(
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
                suffixIcon: Icons.visibility_outlined,
              ),
              const SizedBox(height: 24),

              _buildLabel("Konfirmasi Kata Sandi"),
              _buildTextField(
                hint: "••••••••",
                icon: Icons.history, // Icon sesuai gambar (history/reset)
                isPassword: true,
              ),
              const SizedBox(height: 24),

              // Checkbox & Terms
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: false,
                      onChanged: (v) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textGray,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: "Saya menyetujui "),
                          TextSpan(
                            text: "Syarat dan Ketentuan",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " serta "),
                          TextSpan(
                            text: "Kebijakan Privasi",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " SmartRecruit."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tombol Buat Akun (Main CTA)
              _buildMainButton("Buat Akun", Icons.arrow_forward),

              const SizedBox(height: 48),
              // Footer Link
              Center(
                child: GestureDetector(
                  // UBAH BAGIAN INI:
                  onTap: () => controller.goToLogin(), 
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textGray,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Sudah memiliki akun? "),
                        TextSpan(
                          text: "Masuk di sini",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: AppColors.textGray, size: 20)
            : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FF), // Latar input sesuai gambar
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

  Widget _buildSocialButton(String text) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gunakan Image.asset jika sudah punya logo Google
          const Icon(Icons.g_mobiledata, size: 32, color: Colors.blue), 
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "ATAU",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textGray,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
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
        color: const Color(0xFF0058BE), // Warna Biru Utama
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0058BE).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed('/home'),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}