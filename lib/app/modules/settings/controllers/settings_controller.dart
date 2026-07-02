import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final storage = const FlutterSecureStorage();
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  var isLoading = false.obs;
  var activityLogs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivityLogs();
  }

  // =========================================================
  // GANTI EMAIL
  // =========================================================
  void showChangeEmailDialog() {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: const Text("Ganti Email"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Masukkan email baru dan password Anda untuk konfirmasi.",
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Email Baru"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password Saat Ini"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2170E4)),
          onPressed: () {
            if (emailCtrl.text.trim().isNotEmpty && passwordCtrl.text.isNotEmpty) {
              Get.back();
              changeEmail(emailCtrl.text.trim(), passwordCtrl.text);
            }
          },
          child: const Text("Simpan", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
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
        await storage.write(key: 'user_email', value: newEmail);
        Get.snackbar("Sukses", "Email berhasil diubah. Silakan verifikasi email baru Anda.",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Gagal mengganti email",
            backgroundColor: Colors.red, colorText: Colors.white);
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
    Get.dialog(AlertDialog(
      title: const Text("Ganti Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password Lama"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: newPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password Baru"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmPassCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Konfirmasi Password Baru"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2170E4)),
          onPressed: () {
            if (newPassCtrl.text != confirmPassCtrl.text) {
              Get.snackbar("Error", "Password baru tidak cocok");
              return;
            }
            if (newPassCtrl.text.length < 6) {
              Get.snackbar("Error", "Password minimal 6 karakter");
              return;
            }
            if (oldPassCtrl.text.isNotEmpty && newPassCtrl.text.isNotEmpty) {
              Get.back();
              changePassword(oldPassCtrl.text, newPassCtrl.text);
            }
          },
          child: const Text("Simpan", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
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
        Get.snackbar("Sukses", "Password berhasil diubah",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Gagal mengganti password",
            backgroundColor: Colors.red, colorText: Colors.white);
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
    Get.dialog(AlertDialog(
      title: const Text("Hapus Akun", style: TextStyle(color: Colors.red)),
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
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Masukkan Password untuk Konfirmasi",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (confirmCtrl.text.isNotEmpty) {
              Get.back();
              deleteAccount(confirmCtrl.text);
            }
          },
          child: const Text("Hapus Akun", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  Future<void> deleteAccount(String password) async {
    isLoading.value = true;
    try {
      final response = await apiProvider.delete("/auth/delete-account", query: {"password": password});
      isLoading.value = false;
      if (response.statusCode == 200) {
        await storage.deleteAll();
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar("Akun Dihapus", "Akun Anda telah berhasil dihapus");
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Gagal menghapus akun",
            backgroundColor: Colors.red, colorText: Colors.white);
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
        final logs = List<Map<String, dynamic>>.from(response.body['logs'] ?? []);
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
    Get.dialog(AlertDialog(
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
    ));
  }
}
