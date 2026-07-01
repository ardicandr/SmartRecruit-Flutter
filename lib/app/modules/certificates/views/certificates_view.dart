import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/certificates_controller.dart';

class CertificatesView extends GetView<CertificatesController> {
  const CertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF), // Soft background sesuai HTML
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text("Sertifikat Saya", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 18, backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white, size: 24)),
          )
        ],
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24),
              itemCount: controller.certificates.length,
              itemBuilder: (context, index) {
                var item = controller.certificates[index];
                return _buildCertificateCard(
                  index: index,
                  title: item['title'].toString(),
                  issuer: item['issuer'].toString(),
                  date: item['date'].toString(),
                  color: Color(item['color'] as int),
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  // Banner Biru Muda di atas
  Widget _buildInfoBanner() {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFEEF0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.verified, color: Colors.indigo[600]),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kelola Pencapaian Anda", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[900])),
                SizedBox(height: 4),
                Text(
                  "Sertifikat yang valid akan memberikan nilai tambah 25% lebih tinggi pada profil Anda.",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Card Sertifikat dengan Tombol Aksi
  Widget _buildCertificateCard({required int index, required String title, required String issuer, required String date, required Color color}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Placeholder (Kotak Warna)
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.workspace_premium, color: Colors.black26),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.3)),
                    SizedBox(height: 4),
                    Text(issuer, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                    Text("Diterbitkan: $date", style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: Colors.grey[400]),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              // Tombol Lihat (Lebar)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.open_in_new, size: 16),
                  label: Text("Lihat"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: Colors.grey[200]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Tombol Hapus (Merah)
              OutlinedButton(
                onPressed: () => controller.deleteCertificate(index),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[200]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(12),
                ),
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
              ),
            ],
          )
        ],
      ),
    );
  }
}