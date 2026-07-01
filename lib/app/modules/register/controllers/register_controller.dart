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
  final otpC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();

  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> requestOTP() async {
    if (emailC.text.isEmpty || !GetUtils.isEmail(emailC.text)) {
      Get.snackbar("Error", "Masukkan email yang valid terlebih dahulu");
      return;
    }
    try {
      isLoading.value = true;
      final response = await apiProvider.requestOTP(emailC.text);
      
      if (response.statusCode == 200) {
        isOtpSent.value = true;
        Get.snackbar("Berhasil", "OTP telah dikirim ke email Anda");
      } else {
        String msg = response.body?['message'] ?? "Gagal mengirim OTP";
        Get.snackbar("Gagal", msg);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan koneksi saat meminta OTP");
    } finally {
      isLoading.value = false;
    }
  }

  // Modifikasi fungsi register()
  Future<void> register() async {
    if (nameC.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty || otpC.text.isEmpty) {
      Get.snackbar("Error", "Semua field dan OTP wajib diisi");
      return;
    }
    
    if (passC.text != confirmPassC.text) {
      Get.snackbar("Error", "Konfirmasi kata sandi tidak cocok");
      return;
    }

    try {
      isLoading.value = true;
      // Tambahkan 'otp' ke dalam FormData
      final formData = FormData({
        "username": nameC.text,
        "email": emailC.text,
        "password": passC.text,
        "role": "Pelamar",
        "otp": otpC.text, 
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

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan token dari Google");
        return;
      }

      logger.i("Mencoba registrasi/login via Google OAuth ke Flask...");
      final response = await apiProvider.postGoogleAuth(idToken, action: "register");
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
    } else if (response.statusCode == 201) {
      String msg = response.body?['message'] ?? "Registrasi berhasil, verifikasi dikirim ke email";
      Get.snackbar("Verifikasi Diperlukan", msg, duration: const Duration(seconds: 5));
      Get.offNamed(Routes.LOGIN);
    } else if (response.statusCode == 403) {
      String errorMsg = response.body?['message'] ?? "Verifikasi akun dulu, jika sudah klik button verifikasi yang dikirim di mail baru bisa login";
      Get.snackbar("Verifikasi Diperlukan", errorMsg, duration: const Duration(seconds: 5));
      Get.offNamed(Routes.LOGIN);
    } else {
      String errorMsg = response.body?['message'] ?? "Gagal terhubung ke Google";
      Get.snackbar("Gagal", errorMsg);
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