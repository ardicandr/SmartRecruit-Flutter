import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class RegisterController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> register() async {
    // Validasi Sederhana
    if (nameC.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi");
      return;
    }

    if (passC.text != confirmPassC.text) {
      Get.snackbar("Error", "Konfirmasi kata sandi tidak cocok");
      return;
    }

    try {
      isLoading.value = true;

      final formData = FormData({
        "username": nameC.text,
        "email": emailC.text,
        "password": passC.text,
        "role": "Pelamar",
      });

      final response = await apiProvider.post("/auth/register", formData);

      if (response.statusCode == 201) {
        Get.snackbar("Berhasil", "Akun berhasil dibuat. Silakan login.");
        Get.offNamed(Routes.LOGIN);
      } else {
        String msg = response.body?['message'] ?? "Registrasi Gagal";
        Get.snackbar("Gagal", msg);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan koneksi");
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.toNamed(Routes.LOGIN);

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.onClose();
  }
}