import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';
import 'package:intl/intl.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: Text(
          "Pengaturan Akun",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF2170E4),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2170E4)),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ---- KEAMANAN AKUN (kondisional berdasarkan metode login) ----
                _buildSectionTitle("Keamanan Akun"),
                Obx(() {
                  if (controller.isGoogleLogin) {
                    // Pengguna login via Google: hanya tampilkan opsi ganti akun Google
                    return _buildSettingCard(children: [
                      _buildSettingTile(
                        icon: Icons.manage_accounts_outlined,
                        iconColor: const Color(0xFF2170E4),
                        title: "Ganti Email atau Akun Google",
                        subtitle: "Kelola akun Google yang terhubung",
                        onTap: () => controller.showChangeGoogleAccountDialog(),
                      ),
                    ]);
                  } else {
                    // Pengguna login via email+password: tampilkan Ganti Email & Ganti Password
                    return _buildSettingCard(children: [
                      _buildSettingTile(
                        icon: Icons.email_outlined,
                        iconColor: const Color(0xFF2170E4),
                        title: "Ganti Email",
                        subtitle: "Ubah alamat email akun Anda",
                        onTap: () => controller.showChangeEmailDialog(),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingTile(
                        icon: Icons.lock_outline,
                        iconColor: const Color(0xFF2170E4),
                        title: "Ganti Kata Sandi",
                        subtitle: "Ubah kata sandi login Anda",
                        onTap: () => controller.showChangePasswordDialog(),
                      ),
                    ]);
                  }
                }),

                const SizedBox(height: 20),

                // ---- LOG AKTIVITAS ----
                _buildSectionTitle("Aktivitas"),
                _buildSettingCard(children: [
                  _buildSettingTile(
                    icon: Icons.history,
                    iconColor: const Color(0xFF2170E4),
                    title: "Riwayat Aktivitas",
                    subtitle: "Lihat log masuk dan perubahan akun Anda",
                    onTap: () {
                      controller.fetchActivityLogs();
                      _showActivityLogsBottomSheet(context);
                    },
                  ),
                ]),

                const SizedBox(height: 20),

                // ---- KELUAR ----
                _buildSectionTitle("Sesi"),
                _buildSettingCard(children: [
                  _buildSettingTile(
                    icon: Icons.logout,
                    iconColor: Colors.orange,
                    title: "Keluar",
                    subtitle: "Keluar dari akun Anda",
                    onTap: () => controller.showLogoutDialog(),
                    trailing: const SizedBox.shrink(),
                  ),
                ]),

                const SizedBox(height: 20),

                // ---- HAPUS AKUN ----
                _buildSectionTitle("Zona Bahaya"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: _buildSettingTile(
                    icon: Icons.delete_forever_outlined,
                    iconColor: Colors.red,
                    title: "Hapus Akun",
                    subtitle: "Hapus akun dan semua data secara permanen",
                    titleColor: Colors.red,
                    onTap: () => controller.showDeleteAccountDialog(),
                    trailing: const SizedBox.shrink(),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: titleColor ?? const Color(0xFF1A1A2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showActivityLogsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Riwayat Aktivitas",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            
            // Log List
            Flexible(
              child: Obx(() {
                if (controller.activityLogs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "Tidak ada aktivitas tercatat",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.activityLogs.length,
                  itemBuilder: (context, index) {
                    final log = controller.activityLogs[index];
                    final timestamp = log['timestamp'] != null
                        ? DateTime.tryParse(log['timestamp'].toString())
                        : null;
                        
                    // Menentukan icon berdasarkan aksi
                    IconData iconData = Icons.info_outline;
                    Color iconColor = const Color(0xFF2170E4);
                    String action = log['action']?.toString() ?? "-";
                    
                    if (action.toLowerCase().contains("login")) {
                      iconData = Icons.login_outlined;
                      iconColor = Colors.green;
                    } else if (action.toLowerCase().contains("logout")) {
                      iconData = Icons.logout_outlined;
                      iconColor = Colors.orange;
                    } else if (action.toLowerCase().contains("email")) {
                      iconData = Icons.email_outlined;
                      iconColor = Colors.blue;
                    } else if (action.toLowerCase().contains("password") || action.toLowerCase().contains("sandi")) {
                      iconData = Icons.lock_outline;
                      iconColor = Colors.purple;
                    } else if (action.toLowerCase().contains("update") || action.toLowerCase().contains("profil")) {
                      iconData = Icons.person_outline;
                      iconColor = Colors.teal;
                    } else if (action.toLowerCase().contains("melamar")) {
                      iconData = Icons.work_outline;
                      iconColor = const Color(0xFF2170E4);
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(iconData, color: iconColor, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  action,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timestamp != null
                                      ? DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(timestamp)
                                      : "-",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
