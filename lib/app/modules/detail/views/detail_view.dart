import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/detail_controller.dart';
import '../../../data/models/job_model.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    Map<String, dynamic> jobData = {};
    if (args is JobModel) {
      jobData = {
        'id': args.id,
        'title': args.title,
        'company': args.company,
        'location': args.location,
        'salary': args.salary,
        'postedAt': args.postedAt,
        'category': args.category,
        'department': args.department,
        'employmentType': args.employmentType,
        'description': args.description,
        'requirements': args.requirements,
        'maxApplicants': args.maxApplicants,
        'isApplied': args.isApplied,
        'match': "95%"
      };
    } else if (args is Map) {
      jobData = Map<String, dynamic>.from(args);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text(
          "Detail Lowongan",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        // --- TOMBOL BOOKMARK ---
        actions: [
          Obx(() => IconButton(
            onPressed: () => controller.toggleBookmark(),
            icon: Icon(
              controller.isBookmarked.value ? Icons.bookmark : Icons.bookmark_border_rounded,
              color: controller.isBookmarked.value ? const Color(0xFF2170E4) : Colors.black,
              size: 26,
            ),
          )),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroHeader(jobData),
            const SizedBox(height: 20),
            _buildQuickInfoChips(jobData),
            const SizedBox(height: 32),
            _buildAiMatchCard(jobData),
            const SizedBox(height: 40),
            _buildSectionTitle(Icons.business_center_outlined, "Tentang Pekerjaan"),
            const SizedBox(height: 12),
            Text(
              jobData['description'] ?? "Belum ada deskripsi pekerjaan.",
              style: TextStyle(color: AppColors.textGray, height: 1.6, fontSize: 14),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(Icons.check_circle_outline, "Persyaratan"),
            const SizedBox(height: 16),
            _buildRequirementList((jobData['requirements'] ?? "Belum ada persyaratan detail")
                .toString()
                .split(RegExp(r'\n|- '))
                .where((e) => e.trim().isNotEmpty)
                .toList()),
            const SizedBox(height: 32),
            const Text(
              "KATEGORI & DEPARTEMEN",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [jobData['category'], jobData['department']]
                  .where((e) => e != null)
                  .map((tag) => _buildSkillChip(tag.toString()))
                  .toList(),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(Icons.verified_outlined, "Benefit & Fasilitas"),
            const SizedBox(height: 16),
            ...(jobData['facilities'] != null && jobData['facilities'].toString().trim().isNotEmpty
                ? jobData['facilities']
                    .toString()
                    .split(',')
                    .map<Widget>((e) => _buildBenefitItem(e.trim()))
                    .toList()
                : [
                    _buildBenefitItem("Gaji Kompetitif (Lihat info gaji)"),
                    _buildBenefitItem("Lingkungan Kerja Profesional"),
                    _buildBenefitItem("Kesempatan Pengembangan Karir"),
                  ]),
            const SizedBox(height: 40),
            _buildDottedDivider(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textGray),
                    const SizedBox(width: 8),
                    Text("Diposting pada:", style: TextStyle(color: AppColors.textGray, fontSize: 13)),
                  ],
                ),
                Text(jobData['postedAt'] != null ? jobData['postedAt'].toString().split('T')[0] : "Baru saja", style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomApplyBar(jobData),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildHeroHeader(Map<String, dynamic> data) {
    return Row(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: const Icon(Icons.apartment_rounded, color: Color(0xFF2170E4), size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['title'] ?? "Job Title", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(data['company'] ?? "Company Name", style: const TextStyle(color: Color(0xFF2170E4), fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Row(children: [
                  Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGray),
                  Text(" ${data['location'] ?? 'Jakarta'}", style: TextStyle(color: AppColors.textGray, fontSize: 12)),
              ]),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildQuickInfoChips(Map<String, dynamic> data) {
    return Row(
      children: [
        _buildInfoChip(Icons.attach_money, data['salary'] ?? "Negosiasi"),
        const SizedBox(width: 10),
        _buildInfoChip(Icons.access_time, data['employmentType'] ?? "Full-time"),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[100]!)),
      child: Row(children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF424754))),
      ]),
    );
  }

  Widget _buildAiMatchCard(Map<String, dynamic> data) {
    return Obx(() {
      if (controller.isMatchLoading.value) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.blue[100]!)),
          child: Column(children: [
            Row(children: [
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2170E4))
              ),
              const SizedBox(width: 12),
              Text("Menghitung kecocokan AI...", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: const Color(0xFF001A42), fontSize: 14)),
            ]),
          ]),
        );
      }
      
      double score = controller.aiMatchScore.value;
      String matchStr = "${score.round()}%";
      double matchValue = score / 100.0;
      String reason = controller.aiMatchReason.value;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.blue[100]!)),
        child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                    const Icon(Icons.bolt, color: Color(0xFF2170E4), size: 22),
                    const SizedBox(width: 8),
                    Text("AI Match Score", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: const Color(0xFF001A42), fontSize: 16)),
                ]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF2170E4), borderRadius: BorderRadius.circular(20)), child: Text(matchStr, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 12),
            Text(reason, style: const TextStyle(color: Color(0xFF0058BE), fontSize: 13, height: 1.5)),
            const SizedBox(height: 20),
            ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: matchValue, minHeight: 8, backgroundColor: const Color(0xFFD8E2FF), color: const Color(0xFF2170E4))),
        ]),
      );
    });
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(children: [
        Icon(icon, color: AppColors.textDark, size: 22),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark)),
    ]);
  }

  Widget _buildRequirementList(List<String> items) {
    return Column(children: items.map((text) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_outline, color: Colors.grey, size: 20), const SizedBox(width: 12), Expanded(child: Text(text, style: TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.4)))]))).toList());
  }

  Widget _buildSkillChip(String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)), child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF545F73))));
  }

  Widget _buildBenefitItem(String text) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)), child: Row(children: [const CircleAvatar(radius: 4, backgroundColor: Colors.green), const SizedBox(width: 16), Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF424754)))]));
  }

  Widget _buildDottedDivider() {
    return Row(children: List.generate(40, (index) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: index.isEven ? Colors.grey[300] : Colors.transparent))));
  }

  Widget _buildBottomApplyBar(Map<String, dynamic> jobData) {
    bool isApplied = jobData['isApplied'] ?? false;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.info_outline, size: 14, color: Colors.grey), SizedBox(width: 6), Text("Data Anda akan diproses otomatis oleh AI kami.", style: TextStyle(color: Colors.grey, fontSize: 10))]),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isApplied ? null : () => controller.applyNow(),
            style: ElevatedButton.styleFrom(backgroundColor: isApplied ? Colors.grey : const Color(0xFF2170E4), minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8, shadowColor: Colors.blue.withOpacity(0.4)),
            child: Text(isApplied ? "Sudah Dilamar" : "Lamar Sekarang", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
      ]),
    );
  }
}