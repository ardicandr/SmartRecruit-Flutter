import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var isLoading = false.obs;

  // Controllers for Forgot Password View
  final emailC = TextEditingController();

  // Controllers for OTP Verification View (6 digits)
  final List<TextEditingController> otpC = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  // Controllers for Reset Password View
  final newPassC = TextEditingController();
  final confirmPassC = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  // 1. Fungsi Kirim Instruksi ke Email (Kirim OTP)
  Future<void> sendInstructions() async {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Email wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Error",
        "Alamat email tidak valid",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiProvider.requestForgotPasswordOtp(email);
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.snackbar(
          "Sukses",
          "Kode OTP verifikasi berhasil dikirim ke email Anda",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.VERIFY_OTP);
      } else {
        String msg = response.body?['message'] ?? "Gagal mengirim instruksi";
        Get.snackbar(
          "Gagal",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Terjadi kesalahan sistem saat menghubungi server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // 2. Fungsi Verifikasi Kode OTP
  Future<void> verifyOtp() async {
    final email = emailC.text.trim();
    final otp = otpC.map((c) => c.text.trim()).join();

    if (otp.length < 6) {
      Get.snackbar(
        "Error",
        "Kode OTP lengkap 6 digit wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiProvider.verifyResetOtp(email, otp);
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.snackbar(
          "Sukses",
          "Kode OTP valid. Silakan buat kata sandi baru.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.RESET_PASSWORD);
      } else {
        String msg =
            response.body?['message'] ?? "Kode OTP salah atau kedaluwarsa";
        Get.snackbar(
          "Gagal",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Terjadi kesalahan sistem saat menghubungi server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // 3. Fungsi Update Password Baru
  Future<void> updatePassword() async {
    final email = emailC.text.trim();
    final otp = otpC.map((c) => c.text.trim()).join();
    final newPass = newPassC.text;
    final confirmPass = confirmPassC.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua kolom kata sandi wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar(
        "Error",
        "Kata sandi minimal 6 karakter",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar(
        "Error",
        "Konfirmasi kata sandi tidak cocok",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiProvider.resetPassword(email, otp, newPass);
      isLoading.value = false;
      if (response.statusCode == 200) {
        // Bersihkan text fields
        emailC.clear();
        for (var c in otpC) {
          c.clear();
        }
        newPassC.clear();
        confirmPassC.clear();

        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar(
          "Berhasil",
          "Kata sandi Anda telah diperbarui. Silakan masuk kembali.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF2170E4),
          colorText: Colors.white,
        );
      } else {
        String msg = response.body?['message'] ?? "Gagal mereset kata sandi";
        Get.snackbar(
          "Gagal",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Terjadi kesalahan sistem saat menghubungi server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Kita tidak memanggil dispose di sini karena Getx reuse controllers
    super.onClose();
  }
}
