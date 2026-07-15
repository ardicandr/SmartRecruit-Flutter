import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final storage = const FlutterSecureStorage();
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var isLoading = false.obs;
  var activityLogs = <Map<String, dynamic>>[].obs;
  // 'email' = login dengan email+password, 'google' = login dengan Google
  var loginMethod = 'email'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLoginMethod();
    fetchActivityLogs();
  }

  Future<void> _loadLoginMethod() async {
    final method = await storage.read(key: 'login_method');
    loginMethod.value = method ?? 'email';
  }

  bool get isGoogleLogin => loginMethod.value == 'google';

  // =========================================================
  // GANTI AKUN GOOGLE (khusus pengguna yang login via Google)
  // =========================================================
  void showChangeGoogleAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2170E4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.manage_accounts_outlined,
                color: Color(0xFF2170E4),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text("Ganti Akun Google"),
          ],
        ),
        content: const Text(
          "Pilih akun Google baru yang ingin Anda hubungkan. "
          "Kami akan mengirimkan link verifikasi ke akun Google baru tersebut. "
          "Akun Anda tetap aktif sampai verifikasi selesai.",
          style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2170E4),
            ),
            onPressed: () {
              Get.back();
              _triggerGoogleAccountChange();
            },
            child: const Text(
              "Pilih Akun Google",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Memicu Google Sign-In untuk memilih akun baru,
  /// lalu mengirimkan email tersebut ke backend untuk diproses.
  Future<void> _triggerGoogleAccountChange() async {
    try {
      isLoading.value = true;

      // Paksa sign out dari Google dulu agar user bisa memilih akun baru
      final googleSignIn = GoogleSignIn.instance;
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      // Tampilkan Google account picker
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final newEmail = googleUser.email;
      if (newEmail.isEmpty) {
        Get.snackbar(
          "Error",
          "Gagal mendapatkan email dari akun Google yang dipilih",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _changeGoogleAccount(newEmail);
    } catch (e) {
      // User membatalkan atau terjadi error
      if (!e.toString().contains('cancel') &&
          !e.toString().contains('sign_in_canceled')) {
        Get.snackbar(
          "Error",
          "Gagal memilih akun Google: ${e.toString()}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengirim email Google baru ke backend.
  /// Backend menyimpan ke pending_email dan mengirim link verifikasi.
  Future<void> _changeGoogleAccount(String newEmail) async {
    try {
      final response = await apiProvider.requestGoogleAccountChange(newEmail);

      if (response.statusCode == 200) {
        // Tampilkan dialog sukses yang informatif
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.mark_email_read_outlined,
                  color: Color(0xFF2170E4),
                  size: 26,
                ),
                SizedBox(width: 10),
                Text("Verifikasi Dikirim!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Link verifikasi telah dikirim ke:",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    newEmail,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2170E4),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Buka email tersebut dan klik link verifikasi. "
                  "Akun Anda akan tetap aktif hingga Anda mengkonfirmasi pergantian.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2170E4),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Mengerti",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        final msg = response.body['message'] ?? "Gagal mengirim verifikasi";
        Get.snackbar(
          "Gagal",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan sistem: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // =========================================================
  // GANTI EMAIL
  // =========================================================
  void showChangeEmailDialog() {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    bool isObscure = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Ganti Email"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Masukkan email baru dan password Anda untuk konfirmasi.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Baru"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: "Password Saat Ini",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2170E4),
                ),
                onPressed: () {
                  if (emailCtrl.text.trim().isNotEmpty &&
                      passwordCtrl.text.isNotEmpty) {
                    Get.back();
                    changeEmail(emailCtrl.text.trim(), passwordCtrl.text);
                  }
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> changeEmail(String newEmail, String password) async {
    isLoading.value = true;
    try {
      final response = await apiProvider.put("/auth/change-email", {
        "new_email": newEmail,
        "password": password,
      });
      isLoading.value = false;
      if (response.statusCode == 200) {
        // Jangan ubah storage.write user_email, karena belum diverifikasi
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.mark_email_read_outlined,
                  color: Color(0xFF2170E4),
                  size: 26,
                ),
                SizedBox(width: 10),
                Text("Verifikasi Dikirim!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Link verifikasi telah dikirim ke:",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    newEmail,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2170E4),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Buka email tersebut dan klik link verifikasi. "
                  "Akun Anda akan tetap aktif menggunakan email lama hingga Anda mengkonfirmasi pergantian.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2170E4),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Mengerti",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Gagal mengganti email",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    }
  }

  // =========================================================
  // GANTI PASSWORD
  // =========================================================
  void showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    bool isObscureOld = true;
    bool isObscureNew = true;
    bool isObscureConfirm = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Ganti Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPassCtrl,
                  obscureText: isObscureOld,
                  decoration: InputDecoration(
                    labelText: "Password Lama",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureOld ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscureOld = !isObscureOld;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassCtrl,
                  obscureText: isObscureNew,
                  decoration: InputDecoration(
                    labelText: "Password Baru",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscureNew = !isObscureNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassCtrl,
                  obscureText: isObscureConfirm,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password Baru",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscureConfirm = !isObscureConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2170E4),
                ),
                onPressed: () {
                  if (newPassCtrl.text != confirmPassCtrl.text) {
                    Get.snackbar("Error", "Password baru tidak cocok");
                    return;
                  }
                  if (newPassCtrl.text.length < 6) {
                    Get.snackbar("Error", "Password minimal 6 karakter");
                    return;
                  }
                  if (oldPassCtrl.text.isNotEmpty &&
                      newPassCtrl.text.isNotEmpty) {
                    Get.back();
                    changePassword(oldPassCtrl.text, newPassCtrl.text);
                  }
                },
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    isLoading.value = true;
    try {
      final response = await apiProvider.put("/auth/change-password", {
        "old_password": oldPassword,
        "new_password": newPassword,
      });
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.snackbar(
          "Sukses",
          "Password berhasil diubah",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Gagal mengganti password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    }
  }

  // =========================================================
  // HAPUS AKUN
  // =========================================================
  void showDeleteAccountDialog() {
    final confirmCtrl = TextEditingController();
    bool isObscure = !isGoogleLogin;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Hapus Akun",
              style: TextStyle(color: Colors.red),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Tindakan ini PERMANEN dan tidak dapat dibatalkan. Semua data Anda akan terhapus selamanya.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmCtrl,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: isGoogleLogin ? "Ketik 'HAPUS' untuk Konfirmasi" : "Masukkan Password untuk Konfirmasi",
                    border: const OutlineInputBorder(),
                    suffixIcon: isGoogleLogin ? null : IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  if (isGoogleLogin) {
                    if (confirmCtrl.text != "HAPUS") {
                        Get.snackbar("Error", "Ketik HAPUS untuk melanjutkan.");
                        return;
                    }
                    Get.back();
                    requestDeleteOAuth();
                  } else {
                    if (confirmCtrl.text.isEmpty) {
                        Get.snackbar("Error", "Masukkan password untuk melanjutkan.");
                        return;
                    }
                    Get.back();
                    deleteAccount(confirmCtrl.text);
                  }
                },
                child: const Text(
                  "Hapus Akun",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> requestDeleteOAuth() async {
    isLoading.value = true;
    try {
      final response = await apiProvider.post("/auth/request-delete-oauth", {});
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.mark_email_read_outlined, color: Color(0xFF2170E4), size: 26),
                SizedBox(width: 10),
                Text("Verifikasi Dikirim!"),
              ],
            ),
            content: const Text(
              "Link konfirmasi hapus akun telah dikirim ke email Anda. Silakan cek inbox Anda untuk mengonfirmasi penghapusan akun.",
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2170E4)),
                onPressed: () => Get.back(),
                child: const Text("Mengerti", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Gagal meminta penghapusan akun",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    }
  }

  Future<void> deleteAccount(String password) async {
    isLoading.value = true;
    try {
      final response = await apiProvider.delete(
        "/auth/delete-account",
        query: {"password": password},
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        await storage.deleteAll();
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar("Akun Dihapus", "Akun Anda telah berhasil dihapus");
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Gagal menghapus akun",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    }
  }

  // =========================================================
  // LOG AKTIVITAS
  // =========================================================
  Future<void> fetchActivityLogs() async {
    try {
      final response = await apiProvider.get("/auth/activity-logs");
      if (response.statusCode == 200) {
        final logs = List<Map<String, dynamic>>.from(
          response.body['logs'] ?? [],
        );
        activityLogs.value = logs;
      }
    } catch (e) {
      print("Error fetching activity logs: $e");
      activityLogs.value = [];
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await storage.deleteAll();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
