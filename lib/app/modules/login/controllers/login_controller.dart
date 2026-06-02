import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class LoginController extends GetxController {
  // Gunakan Get.find jika ApiProvider sudah di-inject di Binding
  final ApiProvider apiProvider = Get.find<ApiProvider>(); 
  final storage = const FlutterSecureStorage();
  final logger = Logger();

  final emailC = TextEditingController();
  final passC = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void goToRegister() => Get.toNamed(Routes.REGISTER);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  Future<void> login() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar("Info", "Email dan Password harus diisi");
      return;
    }

    try {
      isLoading.value = true;
      logger.i("Mencoba login ke Flask: ${emailC.text}");
      
      final response = await apiProvider.loginRequest(emailC.text, passC.text);

      if (response.statusCode == 200) {
        // Sesuaikan dengan return jsonify backend Flask kamu
        String token = response.body['token'];
        var userData = response.body['user'];
        
        String username = userData['username'] ?? "User";
        String email = userData['email'] ?? "";
        String role = userData['role'] ?? "Pelamar";

        // Validasi Role: Jika aplikasi Flutter ini khusus Pelamar
        if (role != "Pelamar") {
          Get.snackbar("Akses Ditolak", "Akun HRD silakan login melalui Web Platform.");
          isLoading.value = false;
          return;
        }

        // Simpan ke local storage
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'user_name', value: username);
        await storage.write(key: 'user_email', value: email);

        logger.i("Login Berhasil sebagai $role");
        print("TOKEN SAYA: $token"); 
        
        Get.offAllNamed(Routes.HOME);
      } else {
        // Flask mengembalikan {"message": "..."}
        String errorMsg = response.body?['message'] ?? "Email atau password salah";
        Get.snackbar("Login Gagal", errorMsg);
      }
    } catch (e) {
      logger.e("Koneksi Error: $e");
      Get.snackbar("Error", "Tidak dapat terhubung ke server Flask");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}