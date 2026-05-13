import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const primary = Color(0xFF0058BE);
  static const primaryLight = Color(0xFFD8E2FF);
  static const background = Color(0xFFF8F9FF);
  static const surface = Color(0xFFFFFFFF);
  
  // Warna Teks
  static const textDark = Color(0xFF0B1C30);
  static const textGray = Color(0xFF727785);
  static const textMuted = Color(0xFF6B7280);
  
  // Warna Border & Lainnya
  static const outline = Color(0xFFC2C6D6);
  static const success = Color(0xFF4CAF50);
}

class AppHelpers {
  static void showSnackbar({required String title, required String message, bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red[400]! : const Color(0xFF2170E4),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
      duration: const Duration(seconds: 1),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }
}