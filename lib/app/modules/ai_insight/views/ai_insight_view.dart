import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/ai_insight_controller.dart';

class AiInsightView extends GetView<AiInsightController> {
  const AiInsightView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => controller.handleBack(), 
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text(
          "Analisis Profil AI", 
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
            fontSize: 18
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryHeader(),
            const SizedBox(height: 32),
            _buildRadarChartSection(),
            const SizedBox(height: 40),
            _buildDocumentAnalysisList(),
            const SizedBox(height: 32),
            _buildCareerPathSection(),
            const SizedBox(height: 40),
            _buildFooterButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 1. Kotak Ringkasan Atas (Resume Score)
  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0058BE),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0058BE).withOpacity(0.3), 
            blurRadius: 20, 
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Resume Score Anda:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text("92/100 (Sangat Kuat)", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 2. Grafik Radar (Pilar Profesional)
  Widget _buildRadarChartSection() {
    return Column(
      children: [
        Text(
          "Kekuatan Dokumen & Profil", 
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 220,
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  fillColor: const Color(0xFF2170E4).withOpacity(0.2),
                  borderColor: const Color(0xFF2170E4),
                  entryRadius: 3,
                  dataEntries: [
                    RadarEntry(value: controller.profileScores["Pengalaman"]!), 
                    RadarEntry(value: controller.profileScores["Skill Teknis"]!), 
                    RadarEntry(value: controller.profileScores["Sertifikasi"]!), 
                    RadarEntry(value: controller.profileScores["Pendidikan"]!), 
                    RadarEntry(value: controller.profileScores["Portofolio"]!), 
                  ],
                ),
              ],
              radarShape: RadarShape.circle,
              radarBorderData: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
              gridBorderData: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
              tickBorderData: const BorderSide(color: Colors.transparent),
              getTitle: (index, angle) {
                switch (index) {
                  case 0: return const RadarChartTitle(text: 'Pengalaman');
                  case 1: return const RadarChartTitle(text: 'Skill');
                  case 2: return const RadarChartTitle(text: 'Sertifikat');
                  case 3: return const RadarChartTitle(text: 'Pendidikan');
                  case 4: return const RadarChartTitle(text: 'Portofolio');
                  default: return const RadarChartTitle(text: '');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // 3. Analisis Berdasarkan Ekstraksi Dokumen
  Widget _buildDocumentAnalysisList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hasil Ekstraksi AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        _buildAnalysisItem(Icons.verified, "Sertifikat Terverifikasi", "Ditemukan 3 sertifikat internasional yang relevan dengan industri."),
        _buildAnalysisItem(Icons.description, "Struktur CV Optimal", "Format dokumen Anda sangat mudah dibaca oleh sistem ATS perusahaan."),
        _buildAnalysisItem(Icons.trending_up, "Peningkatan Skill", "Ada tren peningkatan keahlian teknis dalam 2 tahun terakhir."),
      ],
    );
  }

  Widget _buildAnalysisItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF0F7FF), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF2170E4), size: 18)
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4)),
            ],
          ))
        ],
      ),
    );
  }

  // 4. Rekomendasi Jalur Karier
  Widget _buildCareerPathSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF), 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rekomendasi Jalur Karier", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ["Senior Web Developer", "Tech Lead", "System Architect"].map((role) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.1))
              ),
              child: Text(role, style: const TextStyle(fontSize: 12, color: Color(0xFF2170E4), fontWeight: FontWeight.bold)),
            )).toList(),
          )
        ],
      ),
    );
  }

  // 5. Tombol Kembali
  Widget _buildFooterButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Obx(() => ElevatedButton(
        onPressed: () => controller.handleBack(), 
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2170E4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: Colors.blue.withOpacity(0.3)
        ),
        child: Text(
          // LOGIKA TEKS DINAMIS
          controller.origin.value == 'search' 
              ? "Kembali ke Pencarian" 
              : "Kembali ke Profil", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
        ),
      )),
    );
  }
}