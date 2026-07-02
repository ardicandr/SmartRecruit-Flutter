import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final storage = const FlutterSecureStorage();
  final ApiProvider apiProvider = Get.find<ApiProvider>(); 
  
  // State untuk data user
  var name = "Memuat...".obs;
  var email = "...".obs;
  var phoneNumber = "08.. .... ....".obs;
  var profileStrength = 0.85.obs;
  
  var profileImageUrl = "".obs;
  var localImagePath = "".obs;

  File? get localImageFile => localImagePath.value.isNotEmpty ? File(localImagePath.value) : null;

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
    phoneNumber.value = await storage.read(key: 'user_phone') ?? "08.. .... ....";
    
    // Fetch data terbaru dari backend
    try {
      final response = await apiProvider.get("/auth/profile");
      if (response.statusCode == 200) {
        final userData = response.body['user'];
        if (userData != null) {
          name.value = userData['username'] ?? userData['full_name'] ?? name.value;
          phoneNumber.value = userData['phone_number'] ?? phoneNumber.value;
          
          if (userData['image'] != null && userData['image'].toString().isNotEmpty) {
             profileImageUrl.value = "${ApiProvider.hostUrl}${userData['image']}";
          }
          
          await storage.write(key: 'user_name', value: name.value);
          await storage.write(key: 'user_phone', value: phoneNumber.value);
        }
      }
    } catch (e) {
      print("Gagal fetch data profil dari server: $e");
    }
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
  
  void showEditProfileBottomSheet() {
    TextEditingController nameCtrl = TextEditingController(text: name.value);
    TextEditingController phoneCtrl = TextEditingController(text: phoneNumber.value);
    var dialogImagePath = "".obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ubah Profil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
              ]
            ),
            const SizedBox(height: 24, width: double.infinity),
            Center(
              child: GestureDetector(
                onTap: () => showImageSourceDialog(dialogImagePath),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      if (dialogImagePath.value.isNotEmpty) {
                        return CircleAvatar(radius: 50, backgroundImage: FileImage(File(dialogImagePath.value)));
                      } else if (localImagePath.value.isNotEmpty) {
                        return CircleAvatar(radius: 50, backgroundImage: FileImage(File(localImagePath.value)));
                      } else if (profileImageUrl.value.isNotEmpty) {
                        return CircleAvatar(radius: 50, backgroundImage: NetworkImage(profileImageUrl.value));
                      } else {
                        return const CircleAvatar(radius: 50, backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white, size: 50));
                      }
                    }),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                      child: const Icon(Icons.camera_alt, color: Colors.blue, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24, width: double.infinity),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Username", hintText: "Masukkan username baru"),
            ),
            const SizedBox(height: 16, width: double.infinity),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              maxLength: 15,
              decoration: const InputDecoration(
                labelText: "Nomor Telepon", 
                hintText: "Contoh: 081234567890",
                counterText: "",
              ),
            ),
            const SizedBox(height: 32, width: double.infinity),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2170E4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty || phoneCtrl.text.trim().isNotEmpty || dialogImagePath.value.isNotEmpty) {
                    Get.back();
                    updateProfileData(nameCtrl.text.trim(), phoneCtrl.text.trim(), dialogImagePath.value);
                  } else {
                    Get.snackbar("Error", "Minimal isi satu perubahan (Foto, Username, atau Telepon)");
                  }
                },
                child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> updateProfileData(String newUsername, String newPhone, String newImagePath) async {
    try {
      final mapData = <String, dynamic>{};
      
      // Hanya kirim jika tidak kosong dan berbeda dari sebelumnya
      if (newUsername.isNotEmpty && newUsername != name.value) {
        mapData["username"] = newUsername;
      }
      if (newPhone.isNotEmpty && newPhone != phoneNumber.value) {
        mapData["phone_number"] = newPhone;
      }

      final formData = FormData(mapData);

      if (newImagePath.isNotEmpty) {
        formData.files.add(MapEntry("image", MultipartFile(File(newImagePath), filename: newImagePath.split('/').last)));
      }
      
      // Jika tidak ada data yang diubah
      if (mapData.isEmpty && newImagePath.isEmpty) {
        Get.snackbar("Info", "Tidak ada perubahan data yang disimpan");
        return;
      }

      final response = await apiProvider.put("/auth/profile", formData);
      
      if (response.statusCode == 200) {
        if (newUsername.isNotEmpty && newUsername != name.value) name.value = newUsername;
        if (newPhone.isNotEmpty && newPhone != phoneNumber.value) phoneNumber.value = newPhone;
        
        if (newImagePath.isNotEmpty) {
          localImagePath.value = newImagePath;
          profileImageUrl.value = "";
        }
        
        await storage.write(key: 'user_name', value: name.value);
        await storage.write(key: 'user_phone', value: phoneNumber.value);
        
        Get.snackbar("Sukses", "Profil berhasil diperbarui");
      } else {
        Get.snackbar("Error", "Gagal memperbarui profil: ${response.body}");
      }
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar("Error", "Terjadi kesalahan sistem");
    }
  }

  void showImageSourceDialog(RxString dialogImagePath) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Ambil dari Galeri'),
              onTap: () async {
                Get.back();
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) dialogImagePath.value = image.path;
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Buka Kamera'),
              onTap: () async {
                Get.back();
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) dialogImagePath.value = image.path;
              },
            ),
          ],
        ),
      ),
    );
  }

  void goToNotifications() => Get.toNamed(Routes.NOTIFICATION);
}