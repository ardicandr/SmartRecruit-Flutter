import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;

  // 1. Fungsi Kirim Instruksi ke Email
  void sendInstructions() {
    // Simulasi pengiriman email
    Get.toNamed(Routes.VERIFY_OTP);
  }

  // 2. Fungsi Verifikasi Kode OTP
  void verifyOtp() {
    // Simulasi pengecekan kode
    Get.toNamed(Routes.RESET_PASSWORD);
  }

  // 3. Fungsi Update Password Baru
  void updatePassword() {
    // Kembali ke Login dan hapus semua history navigasi lupa password
    Get.offAllNamed(Routes.LOGIN);
    
    // Tampilkan notifikasi sukses menggunakan Helper yang sudah kita buat
    Get.snackbar(
      "Berhasil",
      "Kata sandi Anda telah diperbarui. Silakan masuk kembali.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2170E4),
      colorText: Colors.white,
    );
  }
}