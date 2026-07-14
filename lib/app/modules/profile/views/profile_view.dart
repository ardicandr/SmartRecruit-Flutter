import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';
import '../../../data/providers/api_provider.dart';
import '../../notification/controllers/notification_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
            onPressed: () => controller.goToNotifications(), 
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.black),
                Obx(() {
                  if (Get.isRegistered<NotificationController>()) {
                    final notifC = Get.find<NotificationController>();
                    if (notifC.hasUnread) {
                      return Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),

          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTINGS), 
            icon: const Icon(Icons.settings, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeroProfile(),
            const SizedBox(height: 32),
            _buildStrengthBar(),
            _buildAiAnalysisCard(),
            const SizedBox(height: 24),
            
            // SECTION: CV / RESUME
            _buildSectionHeader(
              "CV & Resume", 
              icon: Icons.contact_page_outlined,
              action: Obx(() => IconButton(
                onPressed: () => controller.goToUploadCv(), 
                icon: Icon(
                  controller.cvUrl.value.isNotEmpty ? Icons.edit : Icons.add_circle_outline, 
                  color: const Color(0xFF2170E4)
                )
              ))
            ),
            Obx(() {
              if (controller.cvUrl.value.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("CV Terverifikasi AI", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Data berhasil diekstrak otomatis", style: TextStyle(color: Colors.grey[700], fontSize: 11)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.goToUploadCv(),
                        child: const Text("Lihat/Ubah"),
                      )
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: CustomDashedButton(text: "Unggah & Scan CV Baru", onTap: () => controller.goToUploadCv()),
                );
              }
            }),

            _buildSectionHeader("DETAIL INFORMASI", action: const SizedBox()),
            
            // EMAIL DINAMIS
            Obx(() => _buildInfoTile(
              Icons.mail_outlined, 
              "EMAIL", 
              controller.email.value
            )),
            
            Obx(() => _buildInfoTile(
              Icons.phone_outlined, 
              "TELEPON", 
              controller.phoneNumber.value
            )),
            const SizedBox(height: 32),
            
            // ... (Bagian Pengalaman & Pendidikan tetap sama) ...
            _buildSectionHeader("Pengalaman Kerja", icon: Icons.work_outlined, action: const SizedBox()),
            Obx(() {
              if (controller.parsedCv.isEmpty || controller.parsedCv['experiences'] == null) {
                return _buildEmptyState("Belum ada data pengalaman kerja. Unggah CV Anda.");
              }
              List experiences = controller.parsedCv['experiences'];
              if (experiences.isEmpty) {
                return _buildEmptyState("Belum ada data pengalaman kerja.");
              }
              return Column(
                children: experiences.map((exp) {
                  return _buildProfileTimelineItem(
                    exp['title'] ?? "-", 
                    exp['company'] ?? "-", 
                    exp['duration'] ?? "-", 
                    exp['description'] ?? ""
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 32),

            _buildSectionHeader("Pendidikan", icon: Icons.school_outlined, action: const SizedBox()),
            Obx(() {
              if (controller.parsedCv.isEmpty || controller.parsedCv['education'] == null) {
                return _buildEmptyState("Belum ada data pendidikan. Unggah CV Anda.");
              }
              List education = controller.parsedCv['education'];
              if (education.isEmpty) {
                return _buildEmptyState("Belum ada data pendidikan.");
              }
              return Column(
                children: education.map((edu) {
                  return _buildProfileTimelineItem(
                    edu['degree'] ?? "-", 
                    edu['institution'] ?? "-", 
                    edu['duration'] ?? "-", 
                    edu['description'] ?? ""
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 32),
            
            _buildSectionHeader("Keahlian Utama", icon: Icons.star_border, action: const SizedBox()),
            Obx(() {
              if (controller.parsedCv.isEmpty || controller.parsedCv['skills'] == null) {
                return _buildEmptyState("Belum ada data keahlian. Unggah CV Anda.");
              }
              List skills = controller.parsedCv['skills'];
              if (skills.isEmpty) {
                return _buildEmptyState("Belum ada data keahlian.");
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return _buildSkillChip(skill.toString(), true);
                }).toList(),
              );
            }),
            const SizedBox(height: 32),

            // SECTION: SERTIFIKAT DINAMIS
            _buildSectionHeader(
              "Sertifikat & Kompetensi", 
              icon: Icons.verified_user_outlined,
              action: IconButton(
                onPressed: () => controller.goToAddCertificate(), 
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2170E4))
              )
            ),

            // LIST SERTIFIKAT DARI BACKEND
            Obx(() {
              if (controller.isLoadingCert.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.certificates.isEmpty) {
                return _buildEmptyState("Belum ada sertifikat ditambahkan");
              }
              return Column(
                children: controller.certificates.map((cert) {
                  return _buildExistingCertificateTile(
                    cert['id'] ?? 0,
                    cert['title'] ?? "Tanpa Judul", 
                    cert['issued_by'] ?? "Tanpa Institusi", 
                    cert['date'] ?? "-",
                    cert['image_url'] ?? ""
                  );
                }).toList(),
              );
            }),

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
        Obx(() {
          if (controller.profileImageUrl.value.isNotEmpty) {
            return CircleAvatar(
              radius: 60, 
              backgroundImage: NetworkImage(controller.profileImageUrl.value),
            );
          } else if (controller.localImagePath.value.isNotEmpty) {
            return CircleAvatar(
              radius: 60, 
              backgroundImage: FileImage(controller.localImageFile!),
            );
          } else {
            return const CircleAvatar(
              radius: 60, 
              backgroundColor: Colors.blue, 
              child: Icon(Icons.person, color: Colors.white, size: 60)
            );
          }
        }),
        const SizedBox(height: 16),
        // NAMA DINAMIS
        Obx(() => Text(
          controller.name.value, 
          style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800)
        )),
        const Text("Pencari Kerja Aktif", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => controller.showEditProfileBottomSheet(),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0F7FF),
            foregroundColor: const Color(0xFF2170E4),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, style: BorderStyle.solid),
      ),
      child: Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
        Obx(() => Text(
          controller.profileStrength.value > 0.0 
              ? "Skor berdasarkan analisis cerdas AI pada profil Anda" 
              : "Lengkapi profil & jalankan analisis AI untuk mendapatkan skor!", 
          textAlign: TextAlign.center, 
          style: const TextStyle(fontSize: 11, color: Colors.blue, fontStyle: FontStyle.italic)
        )),
      ]),
    );
  }

  Widget _buildExistingCertificateTile(int id, String title, String issuer, String date, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty 
                ? Image.network(
                    "${ApiProvider.hostUrl}$imageUrl", 
                    width: 40, 
                    height: 40, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, color: Colors.red);
                    },
                  )
                : const Icon(Icons.description, color: Color(0xFF2170E4)),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("Oleh: $issuer • $date", style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          
          TextButton(
            onPressed: () {
              if (imageUrl.isNotEmpty) {
                Get.dialog(
                  Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            "${ApiProvider.hostUrl}$imageUrl",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                Get.snackbar(
                  "Informasi", 
                  "Gambar sertifikat tidak tersedia",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }, 
            child: const Text("Lihat"),
          ),

          IconButton(
            onPressed: () => controller.confirmDelete(id), 
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAnalysisCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF2170E4), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Analisis Cerdas AI",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "AI kami telah membedah CV dan Sertifikat Anda. Lihat bagaimana profil Anda bersaing di industri saat ini.",
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.goToAiInsight(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2170E4),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Lihat Hasil Analisis Profil", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
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
  Widget _buildInfoTile(IconData icon, String label, String value, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.grey, size: 20)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ]),
        ),
        if (action != null) action,
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
  const CustomDashedButton({super.key, required this.text, required this.onTap});
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