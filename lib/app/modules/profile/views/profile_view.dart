import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart'; // Import Routes
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF2170E4),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=4"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeroProfile(),
            const SizedBox(height: 32),
            _buildStrengthBar(),
            const SizedBox(height: 40),
            _buildSectionHeader("DETAIL INFORMASI", 
                action: _buildSmallButton("Simpan Perubahan")),
            _buildInfoTile(Icons.mail_outlined, "EMAIL", "budi.santoso@email.com"),
            _buildInfoTile(Icons.phone_outlined, "TELEPON", "+62 812 3456 7890"),
            const SizedBox(height: 32),
            
            // SECTION: PENGALAMAN
            _buildSectionHeader("Pengalaman Kerja", icon: Icons.work_outlined),
            _buildProfileTimelineItem(
              "Senior Frontend Engineer", 
              "TechGiant Solutions", 
              "2021 - SEKARANG", 
              "Memimpin tim pengembang untuk membangun platform e-commerce skala besar."
            ),
            _buildDashedButton("+ Tambah Pengalaman", () => _showFormBottomSheet("Pengalaman")),
            
            const SizedBox(height: 32),
            
            // SECTION: PENDIDIKAN
            _buildSectionHeader("Pendidikan", icon: Icons.school_outlined),
            _buildProfileTimelineItem(
              "Sarjana Ilmu Komputer", 
              "Universitas Indonesia", 
              "2014 - 2018", 
              "IPK: 3.85 / 4.00. Fokus pada Rekayasa Perangkat Lunak."
            ),
            _buildDashedButton("+ Tambah Pendidikan", () => _showFormBottomSheet("Pendidikan")),
            
            const SizedBox(height: 32),
            
            // SECTION: KEAHLIAN
            _buildSectionHeader("Keahlian", icon: Icons.lightbulb_outlined),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _buildSkillChip("React.js", true), 
              _buildSkillChip("TypeScript", true), 
              _buildSkillChip("Tailwind CSS", true),
              _buildSkillChip("Node.js", false), 
              _buildSkillChip("UI/UX Design", false), 
              _buildSkillChip("+ Tambah", false, isDashed: true),
            ]),
            
            const SizedBox(height: 32),
            _buildLanguageSection(),
            const SizedBox(height: 32),
            
            // SECTION: SERTIFIKAT (Diarahkan ke Halaman EditProfile)
            _buildSectionHeader(
              "Sertifikat & Kompetensi", 
              icon: Icons.verified_user_outlined,
              action: IconButton(
                onPressed: () => Get.toNamed(Routes.EDIT_PROFILE), 
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2170E4))
              )
            ),
            _buildExistingCertificateTile(), // Menampilkan sertifikat yang sudah ada
            
            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeroProfile() {
    return Column(
      children: [
        Stack(alignment: Alignment.bottomRight, children: [
          const CircleAvatar(radius: 60, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=4")),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: const Icon(Icons.verified, color: Colors.blue, size: 24),
          ),
        ]),
        const SizedBox(height: 16),
        Text("Budi Santoso", style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800)),
        const Text("Senior Frontend Developer", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/upload-cv', arguments: {'isFromApplication': false});
              },
              icon: const Icon(Icons.add),
              label: const Text("Perbarui CV"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2170E4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
            )
          ),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined, size: 18), label: const Text("Bagikan"), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
        ]),
      ],
    );
  }

  Widget _buildStrengthBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("KEKUATAN PROFIL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2170E4))),
          Obx(() => Text("${(controller.profileStrength.value * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2170E4)))),
        ]),
        const SizedBox(height: 12),
        Obx(() => LinearProgressIndicator(value: controller.profileStrength.value, backgroundColor: Colors.blue[100], color: Colors.blue, minHeight: 6)),
        const SizedBox(height: 12),
        const Text("Lengkapi profil untuk mencapai 100%!", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.blue, fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _buildExistingCertificateTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Color(0xFF2170E4)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AWS Certified Solutions Architect", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("Diterbitkan: Jun 2023", style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("Lihat"))
        ],
      ),
    );
  }

  Widget _buildDashedButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CustomDashedButton(text: text, onTap: onTap),
    );
  }

  // MODAL BOTTOM SHEET UNTUK FORM CEPAT
  void _showFormBottomSheet(String title) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Wrap(
          children: [
            Text("Tambah $title", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const TextField(decoration: InputDecoration(labelText: "Nama Instansi / Perusahaan")),
            const TextField(decoration: InputDecoration(labelText: "Posisi / Gelar")),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2170E4), minimumSize: const Size(double.infinity, 50)),
                child: const Text("Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- REUSABLE HELPERS ---
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.grey, size: 20)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ])
      ]),
    );
  }

  Widget _buildSkillChip(String label, bool isSelected, {bool isDashed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2170E4) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: isDashed ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon, Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(children: [
        if (icon != null) Icon(icon, color: const Color(0xFF2170E4), size: 22),
        if (icon != null) const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        if (action != null) action else const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
      ]),
    );
  }

  Widget _buildSmallButton(String text) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)));
  }

  Widget _buildProfileTimelineItem(String title, String company, String date, String desc) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF2170E4), width: 2))),
        Container(width: 1, height: 80, color: Colors.grey[200]),
      ]),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)), child: Text(date, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey))),
        ]),
        Text(company, style: const TextStyle(color: Color(0xFF2170E4), fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.5)),
        const SizedBox(height: 20),
      ]))
    ]);
  }

  Widget _buildLanguageSection() {
    return Column(children: [
      _buildSectionHeader("Bahasa", action: const Text("Edit", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))),
      _buildLangRow("Bahasa Indonesia", "Native"),
      const SizedBox(height: 12),
      _buildLangRow("Bahasa Inggris", "Professional (TOEFL 600)", isBlue: true),
    ]);
  }

  Widget _buildLangRow(String lang, String level, {bool isBlue = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(lang, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(level, style: TextStyle(color: isBlue ? const Color(0xFF2170E4) : Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
    ]);
  }
}

// --- DASHED BUTTON PAINTER ---
class CustomDashedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomDashedButton({Key? key, required this.text, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashPainter(),
        child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF2170E4), fontWeight: FontWeight.bold, fontSize: 14))),
      ),
    );
  }
}

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5;
    final paint = Paint()..color = const Color(0xFF2170E4).withOpacity(0.3)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    RRect rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12));
    Path path = Path()..addRRect(rect);
    Path dashPath = Path();
    for (var pathMetric in path.computeMetrics()) {
      double distance = 0;
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}