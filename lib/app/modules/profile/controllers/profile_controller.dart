import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final storage = const FlutterSecureStorage();
  final ApiProvider apiProvider = Get.find<ApiProvider>(); 
  
  // State untuk data user
  var name = "Memuat...".obs;
  var email = "...".obs;
  var profileStrength = 0.85.obs;

  // State untuk data sertifikat & CV
  var certificates = <dynamic>[].obs;
  var isLoadingCert = false.obs;
  
  var cvUrl = "".obs;
  var parsedCv = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchCertificates();
    fetchUserCv();
  }

  // Ambil data user dari secure storage
  void loadUserData() async {
    name.value = await storage.read(key: 'user_name') ?? "User";
    email.value = await storage.read(key: 'user_email') ?? "email@gmail.com";
  }

  // Ambil list sertifikat dari FastAPI
  Future<void> fetchCertificates() async {
    try {
      isLoadingCert.value = true;
      final response = await apiProvider.get("/certificates");
      
      if (response.statusCode == 200) {
        certificates.assignAll(response.body);
      } else {
        print("Gagal mengambil sertifikat: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching certificates: $e");
    } finally {
      isLoadingCert.value = false;
    }
  }

  void goToAddCertificate() async {
    await Get.toNamed(Routes.ADD_CERTIFICATE);
    // Selalu refresh data setelah kembali dari halaman tambah (mengatasi bug tidak muncul)
    fetchCertificates();
  }

  Future<void> fetchUserCv() async {
    try {
      final response = await apiProvider.getUserCv();
      if (response.statusCode == 200) {
        cvUrl.value = response.body['cv_url'] ?? "";
        parsedCv.value = response.body['parsed_cv'] ?? {};
      }
    } catch (e) {
      print("Error fetching CV: $e");
    }
  }

  void goToUploadCv() async {
    await Get.toNamed(Routes.UPLOAD_CV, arguments: {'isFromApplication': false});
    // Refresh CV
    fetchUserCv();
  }

  void confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus Sertifikat"),
        content: const Text("Apakah Anda yakin ingin menghapus sertifikat ini?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back(); // Tutup dialog secara paksa dan aman
              deleteCertificate(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteCertificate(int id) async {
    try {
      final response = await apiProvider.deleteCertificate(id);
      if (response.statusCode == 200) {
        certificates.removeWhere((cert) => cert['id'] == id);
        Get.snackbar("Sukses", "Sertifikat berhasil dihapus");
      } else {
        Get.snackbar("Error", "Gagal menghapus sertifikat");
      }
    } catch (e) {
      print("Error delete: $e");
    }
  }
  
  void logout() async {
    await storage.deleteAll();
    Get.offAllNamed(Routes.LOGIN);
  }

  void goToNotifications() => Get.toNamed(Routes.NOTIFICATION);
}