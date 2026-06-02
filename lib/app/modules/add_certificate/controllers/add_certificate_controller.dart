import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/api_provider.dart';

class AddCertificateController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final ImagePicker _picker = ImagePicker();

  final titleC = TextEditingController();
  final institutionC = TextEditingController();
  final dateC = TextEditingController();
  
  var isLoading = false.obs;
  XFile? selectedImage;

  Future<void> pickAndScanImage() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    
    if (selectedImage != null) {
      try {
        isLoading.value = true;
        // 1. Jalankan OCR
        final formData = FormData({
          'file': MultipartFile(await selectedImage!.readAsBytes(), filename: 'cert.jpg'),
        });

        final response = await apiProvider.post("/ocr/scan", formData);

        if (response.statusCode == 200) {
          titleC.text = response.body['title'] ?? "";
          institutionC.text = response.body['issued_by'] ?? "";
          dateC.text = response.body['date'] ?? "";
          Get.snackbar("Sukses OCR", "Data berhasil diekstrak otomatis");
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal memproses gambar");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> saveCertificate() async {
    if (titleC.text.isEmpty || institutionC.text.isEmpty) {
      Get.snackbar("Error", "Nama dan Institusi harus diisi");
      return;
    }

    try {
      isLoading.value = true;

      final formData = FormData({
        "title": titleC.text,
        "issued_by": institutionC.text,
        "date": dateC.text,
        if (selectedImage != null)
          "file": MultipartFile(
            await selectedImage!.readAsBytes(), 
            filename: 'certificate.jpg'
          ),
      });


      final response = await apiProvider.post("/certificates/add", formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(result: true);
        Get.snackbar("Sukses", "Sertifikat berhasil disimpan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan: $e");
    } finally {
      isLoading.value = false;
    }
  }

}