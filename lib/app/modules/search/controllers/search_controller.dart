import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_routes.dart';

class AppSearchController extends GetxController { 
  final _api = ApiProvider();
  
  var selectedFilter = "".obs; // "Remote", "Gaji Tinggi", dll.
  var searchQuery = "".obs;
  
  var isLoading = true.obs;
  var hasUploadedDocs = false.obs;
  
  var allJobs = <Map<String, dynamic>>[].obs;
  var filteredJobs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);
    try {
      // Fetch Jobs
      final res = await _api.getJobs();
      if (res.isOk) {
        final List<dynamic> data = res.body;
        allJobs.assignAll(data.map((e) => e as Map<String, dynamic>).toList());
      }
      
      // Check User Profile (CV/Certificates)
      final userRes = await _api.get("/users/me");
      if (userRes.isOk) {
        final userData = userRes.body;
        if ((userData['cv_url'] != null && userData['cv_url'] != '') || 
            (userData['parsed_cv'] != null && userData['parsed_cv'] != '')) {
          hasUploadedDocs(true);
        }
      }
    } catch (e) {
      print("Error Search: $e");
    } finally {
      applyFilter();
      isLoading(false);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applyFilter();
  }

  void changeFilter(String value) {
    if (selectedFilter.value == value) {
      selectedFilter.value = ""; // Toggle off
    } else {
      selectedFilter.value = value;
    }
    applyFilter();
  }

  void applyFilter() {
    var result = allJobs.toList();
    
    // Text search
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((job) {
        final title = (job['title'] ?? '').toString().toLowerCase();
        final company = (job['company_name'] ?? '').toString().toLowerCase();
        return title.contains(q) || company.contains(q);
      }).toList();
    }
    
    // Chips filter
    if (selectedFilter.value == "Remote") {
      result = result.where((job) => job['employment_type'] == 'Remote').toList();
    } else if (selectedFilter.value == "Gaji Tinggi") {
      // Just an example logic: contains "jt" and numbers > 10, or just sort
      // To keep it simple, we just assume we skip or filter if salary text exists
      result = result.where((job) => job['salary_range'] != null).toList();
    } else if (selectedFilter.value == "Fresh Graduate") {
      result = result.where((job) => (job['requirements'] ?? '').toString().toLowerCase().contains('fresh graduate')).toList();
    }
    
    filteredJobs.assignAll(result);
  }

  void goToAiInsight() {
    if (!hasUploadedDocs.value) {
      Get.snackbar(
        "Dokumen Diperlukan", 
        "Silakan unggah CV terlebih dahulu di halaman Profil untuk menggunakan rekomendasi AI.",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }
    Get.toNamed(Routes.AI_INSIGHT, arguments: 'search');
  }
}