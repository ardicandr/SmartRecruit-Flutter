import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/interview_controller.dart';

class InterviewDetailView extends GetView<InterviewController> {
  const InterviewDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MENANGKAP DATA YANG DIKLIK DARI HALAMAN DAFTAR
    final Map<String, dynamic> data = Get.arguments;
    bool isOnline = data['isOnline'] ?? true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text("Detail Wawancara", 
          style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(data),
            const SizedBox(height: 24),
            
            // Detail khusus sesuai tipe (Online/Onsite)
            isOnline ? _buildOnlineDetails(data) : _buildOnsiteDetails(data),
            
            const SizedBox(height: 32),
            const Text("Persiapan Wawancara", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildPrepItem("1", "Pastikan koneksi internet stabil."),
            _buildPrepItem("2", "Gunakan pakaian formal profesional."),
            _buildPrepItem("3", "Siapkan portofolio terbaru."),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.snackbar("Info", isOnline ? "Link Zoom disalin!" : "Membuka Maps..."),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2170E4),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                isOnline ? "Salin Link Meeting" : "Petunjuk Arah (Maps)",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['role'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(data['company'], style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
          const Divider(height: 40),
          _buildDetailRow(Icons.calendar_month, "Tanggal", data['date']),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.access_time, "Waktu", data['time']),
          const SizedBox(height: 16),
          _buildDetailRow(data['isOnline'] ? Icons.videocam : Icons.location_on, "Metode", data['isOnline'] ? "Online (Zoom)" : "Onsite (Tatap Muka)"),
        ],
      ),
    );
  }

  Widget _buildOnlineDetails(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("INFORMASI ZOOM", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text("Meeting ID: ${data['meetingId']}", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Passcode: ${data['passcode']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOnsiteDetails(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("LOKASI KANTOR", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(data['location'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(data['address'] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text("PIC: ${data['pic']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 20, color: const Color(0xFF2170E4)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ])
    ]);
  }

  Widget _buildPrepItem(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        CircleAvatar(radius: 12, backgroundColor: const Color(0xFF2170E4).withOpacity(0.1), child: Text(num, style: const TextStyle(fontSize: 12, color: Color(0xFF2170E4), fontWeight: FontWeight.bold))),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey))),
      ]),
    );
  }
}