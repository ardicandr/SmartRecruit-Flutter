import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class RegisterController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final storage = const FlutterSecureStorage();
  final logger = Logger();

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

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final googleSignIn = GoogleSignIn.instance;

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token dari Google");
        return;
      }

      logger.i("Mencoba registrasi/login via Google OAuth ke Flask...");
      final response = await apiProvider.postGoogleAuth(idToken);
      _handleAuthResponse(response);

    } catch (error) {
      logger.e("Error Google Sign In: $error");
      Get.snackbar("Error", "Terjadi kesalahan saat daftar dengan Google");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthResponse(Response response) async {
    if (response.statusCode == 200) {
      String token = response.body['token'];
      var userData = response.body['user'];
      
      String username = userData['username'] ?? "User";
      String email = userData['email'] ?? "";
      String role = userData['role'] ?? "Pelamar";

      if (role != "Pelamar") {
        Get.snackbar("Akses Ditolak", "Akun HRD silakan login melalui Web Platform.");
        return;
      }

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_name', value: username);
      await storage.write(key: 'user_email', value: email);

      logger.i("Registrasi/Login Berhasil sebagai $role");
      
      Get.offAllNamed(Routes.HOME);
    } else {
      String errorMsg = response.body?['message'] ?? "Gagal terhubung ke Google";
      Get.snackbar("Login Gagal", errorMsg);
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