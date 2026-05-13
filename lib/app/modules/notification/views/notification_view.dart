import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text("Notifikasi", style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildNotificationItem(
            title: "Lamaran Diterima",
            desc: "Selamat! Lamaran Anda di TechNova Solutions telah lolos tahap screening AI.",
            time: "2 jam yang lalu",
            isNew: true,
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
          _buildNotificationItem(
            title: "Jadwal Wawancara",
            desc: "HRD GoCreative Agency mengundang Anda untuk sesi wawancara user besok jam 10:00.",
            time: "5 jam yang lalu",
            isNew: true,
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
          ),
          _buildNotificationItem(
            title: "Tips Karir",
            desc: "Lengkapi profil LinkedIn Anda untuk meningkatkan peluang dilirik rekruter hingga 40%.",
            time: "1 hari yang lalu",
            isNew: false,
            icon: Icons.lightbulb,
            iconColor: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({required String title, required String desc, required String time, required bool isNew, required IconData icon, required Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isNew ? Border.all(color: const Color(0xFF2170E4).withOpacity(0.3)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: iconColor.withOpacity(0.1), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    if (isNew) const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4)),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}