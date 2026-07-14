import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/notification_service.dart';

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
      _isGoogleLogin = false; // login email/password
      logger.i("Mencoba login ke Flask: ${emailC.text}");

      final response = await apiProvider.loginRequest(emailC.text, passC.text);
      _handleAuthResponse(response);
    } catch (e) {
      logger.e("Koneksi Error: $e");
      Get.snackbar("Error", "Tidak dapat terhubung ke server Flask");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      _isGoogleLogin = true; // login via Google
      final googleSignIn = GoogleSignIn.instance;

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        // User membatalkan dialog login
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token dari Google");
        return;
      }

      logger.i("Mencoba login via Google OAuth ke Flask...");
      final response = await apiProvider.postGoogleAuth(idToken);
      _handleAuthResponse(response);
    } catch (error) {
      logger.e("Error Google Sign In: $error");
      Get.snackbar("Error", "Terjadi kesalahan saat login dengan Google");
    } finally {
      isLoading.value = false;
    }
  }

  // Flag untuk menentukan apakah response ini dari Google
  bool _isGoogleLogin = false;

  void _handleAuthResponse(Response response) async {
    if (response.statusCode == 200) {
      String token = response.body['token'];
      var userData = response.body['user'];

      String username = userData['username'] ?? "User";
      String email = userData['email'] ?? "";
      String role = userData['role'] ?? "Pelamar";

      if (role != "Pelamar") {
        Get.snackbar(
          "Akses Ditolak",
          "Akun HRD silakan login melalui Web Platform.",
        );
        return;
      }

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_name', value: username);
      await storage.write(key: 'user_email', value: email);
      // Simpan metode login untuk digunakan di halaman settings
      await storage.write(
        key: 'login_method',
        value: _isGoogleLogin ? 'google' : 'email',
      );

      logger.i(
        "Login Berhasil sebagai $role (metode: ${_isGoogleLogin ? 'google' : 'email'})",
      );

      // Kirim ulang FCM Token setelah login sukses karena sebelumnya mungkin jwt_token belum ada
      if (Get.isRegistered<NotificationService>()) {
        Get.find<NotificationService>().sendTokenToBackendNow();
      }

      Get.offAllNamed(Routes.HOME);
    } else if (response.statusCode == 403) {
      String errorMsg =
          response.body?['message'] ??
          "Verifikasi akun dulu, klik button verifikasi yang dikirim di mail baru bisa login";
      Get.snackbar(
        "Verifikasi Diperlukan",
        errorMsg,
        duration: const Duration(seconds: 5),
      );
    } else if (response.statusCode == 201) {
      String msg =
          response.body?['message'] ??
          "Registrasi berhasil, verifikasi dikirim ke email";
      Get.snackbar(
        "Verifikasi Diperlukan",
        msg,
        duration: const Duration(seconds: 5),
      );
    } else {
      String errorMsg =
          response.body?['message'] ?? "Email atau password salah";
      Get.snackbar("Login Gagal", errorMsg);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
