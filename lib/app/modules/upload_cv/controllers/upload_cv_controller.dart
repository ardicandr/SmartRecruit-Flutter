import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_routes.dart';
import '../../../data/providers/api_provider.dart';

class UploadCvController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final ImagePicker _picker = ImagePicker();

  var isFromApplication = false.obs;
  var isLoading = false.obs;
  var jobId = 0;

  var selectedImage = Rx<XFile?>(null);

  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final experienceC = TextEditingController();
  var skills = <String>[].obs;

  // Data lengkap ekstraksi dari backend untuk mencegah field hilang (projects, education, dll)
  var fullExtractedData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      isFromApplication.value = Get.arguments['isFromApplication'] ?? false;
      jobId = Get.arguments['jobId'] ?? 0;
    }
    fetchExistingCv();
  }

  Future<void> fetchExistingCv() async {
    try {
      isLoading.value = true;
      final response = await apiProvider.getUserCv();
      if (response.statusCode == 200 && response.body['parsed_cv'] != null) {
        final parsed = response.body['parsed_cv'];
        fullExtractedData.value = parsed;
        fullNameC.text = parsed['full_name'] ?? "";
        emailC.text = parsed['email'] ?? "";
        phoneC.text = parsed['phone'] ?? "";
        experienceC.text = parsed['last_experience'] ?? "";

        if (parsed['skills'] != null) {
          skills.assignAll(List<String>.from(parsed['skills']));
        }
      }
    } catch (e) {
      print("Error fetching CV: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndScanCv() async {
    selectedImage.value = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage.value != null) {
      try {
        isLoading.value = true;
        final formData = FormData({
          'file': MultipartFile(
            await selectedImage.value!.readAsBytes(),
            filename: 'cv_scan.jpg',
          ),
        });

        final response = await apiProvider.scanCv(formData);

        if (response.statusCode == 200) {
          // Simpan seluruh raw response agar data "experiences", "education", dll tidak hilang
          fullExtractedData.value = response.body;

          fullNameC.text = response.body['full_name'] ?? "";
          emailC.text = response.body['email'] ?? "";
          phoneC.text = response.body['phone'] ?? "";

          // last_experience mungkin diganti dengan array experiences di backend baru
          String defaultExp = "";
          if (response.body['last_experience'] != null) {
            defaultExp = response.body['last_experience'];
          } else if (response.body['experiences'] != null &&
              response.body['experiences'] is List &&
              response.body['experiences'].isNotEmpty) {
            var firstExp = response.body['experiences'][0];
            defaultExp =
                "${firstExp['title'] ?? ''} at ${firstExp['company'] ?? ''}";
          }
          experienceC.text = defaultExp;

          if (response.body['skills'] != null) {
            skills.assignAll(List<String>.from(response.body['skills']));
          }
          Get.snackbar("Sukses", "Data CV berhasil diekstrak");
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal memproses gambar CV");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> handleFinalAction() async {
    try {
      isLoading.value = true;

      // Gunakan seluruh data ekstraksi awal agar field "projects", "education", dll ikut terkirim
      final parsedCvMap = Map<String, dynamic>.from(fullExtractedData.value);

      // Update/Timpa field yang mungkin telah diedit oleh user secara manual di UI
      parsedCvMap["full_name"] = fullNameC.text;
      parsedCvMap["email"] = emailC.text;
      parsedCvMap["phone"] = phoneC.text;
      parsedCvMap["last_experience"] = experienceC.text;
      parsedCvMap["skills"] = skills.toList();

      final formData = FormData({
        "parsed_cv": jsonEncode(parsedCvMap),
        if (selectedImage.value != null)
          "file": MultipartFile(
            await selectedImage.value!.readAsBytes(),
            filename: 'my_cv.jpg',
          ),
      });

      final response = await apiProvider.saveCv(formData);

      if (response.statusCode == 200) {
        if (isFromApplication.value) {
          final applyRes = await apiProvider.applyJob(jobId);
          if (applyRes.statusCode == 200 || applyRes.statusCode == 201) {
            Get.offAllNamed(Routes.HOME);
            Get.snackbar(
              "Lamaran Terkirim",
              "Lamaran Anda telah diterima oleh HRD.",
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              "Error",
              applyRes.body['message'] ?? "Gagal mengirim lamaran",
            );
          }
        } else {
          Get.back(result: true);
          Get.snackbar(
            "Profil Diperbarui",
            "CV Anda telah berhasil diupdate.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar("Error", "Gagal menyimpan CV");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan jaringan");
    } finally {
      isLoading.value = false;
    }
  }
}
