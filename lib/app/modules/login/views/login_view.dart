import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("SmartRecruit", style: GoogleFonts.plusJakartaSans(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 20)),
              SizedBox(height: 48),
              Text("Selamat Datang\nKembali!", style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textDark, height: 1.2)),
              SizedBox(height: 12),
              Text("Masuk untuk mengelola lamaran dan temukan peluang karir impian Anda.", style: TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.5)),
              SizedBox(height: 32),

              // Tombol Google
              _buildSocialButton("Lanjutkan dengan Google", "assets/google_logo.png"), 

              SizedBox(height: 32),
              _buildDivider(),
              SizedBox(height: 32),

              _buildLabel("Alamat Email"),
              _buildTextField(hint: "nama@email.com", icon: Icons.email_outlined),

              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Kata Sandi"),
                  Text("Lupa kata sandi?", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              _buildTextField(hint: "........", icon: Icons.lock_outline, isPassword: true, suffixIcon: Icons.visibility_outlined),

              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 24, height: 24, child: Checkbox(value: false, onChanged: (v) {}, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
                  SizedBox(width: 8),
                  Text("Ingat saya di perangkat ini", style: TextStyle(color: AppColors.textGray, fontSize: 13)),
                ],
              ),

              SizedBox(height: 32),
              _buildMainButton("Masuk Sekarang", Icons.arrow_forward),

              SizedBox(height: 48),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.textGray, fontSize: 14),
                    children: [
                      TextSpan(text: "Belum punya akun? "),
                      TextSpan(text: "Daftar di sini", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS (Untuk Konsistensi) ---

  Widget _buildLabel(String label) => Padding(padding: EdgeInsets.only(bottom: 8), child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)));

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false, IconData? suffixIcon}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textGray, size: 20),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textGray, size: 20) : null,
        contentPadding: EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outline.withOpacity(0.5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }

  Widget _buildSocialButton(String text, String assetPath) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outline.withOpacity(0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.g_mobiledata, size: 30), // Ganti dengan Image.asset logo google kamu
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.outline.withOpacity(0.5))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("ATAU", style: TextStyle(color: AppColors.textGray, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
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
        color: Color(0xFF3B82F6), // Biru tombol
        boxShadow: [BoxShadow(color: Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}