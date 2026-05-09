import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Sertifikat"), backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputLabel("NAMA SERTIFIKAT / LOMBA"),
            _buildTextField("Contoh: Google Professional Cloud Architect"),
            
            _buildInputLabel("PENYELENGGARA / INSTITUSI"),
            _buildTextField("Contoh: Coursera, BNSP, Puspresnas"),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel("TANGGAL TERBIT"),
                      _buildTextField("Pilih Tanggal", icon: Icons.calendar_today),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel("DOKUMEN"),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.upload, size: 16, color: AppColors.primary), Text(" Upload PDF", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary))])),
                      )
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5, shadowColor: AppColors.primary.withOpacity(0.3)
              ),
              child: Text("Simpan Sertifikat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20, left: 4),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey[400], letterSpacing: 1)),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey[300], size: 18) : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }
}