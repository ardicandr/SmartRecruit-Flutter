import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/status_controller.dart';

class StatusView extends GetView<StatusController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Status Lamaran", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF2170E4), fontWeight: FontWeight.w800, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
          onPressed: () => controller.goToNotifications(), 
          icon: const Icon(Icons.notifications_none, color: Colors.black),),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 16, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=a")),
          )
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildUpdateAlert(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Daftar Lamaran (3)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("URUTKAN: TERBARU v", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildJobStatusCard(
                  title: "Senior UI/UX Designer",
                  company: "TechNova Solutions",
                  location: "Jakarta Selatan (Remote)",
                  match: 94,
                  status: "Wawancara Terjadwal",
                  activities: [
                    {"title": "Lamaran Terkirim", "time": "12 Okt 2023", "isDone": true},
                    {"title": "Lolos Screening AI", "time": "14 Okt 2023", "isDone": true, "note": "CV Anda cocok dengan 9 dari 10 kriteria utama."},
                    {"title": "Wawancara User", "time": "20 Okt 2023", "isDone": false, "note": "Jadwal: Jumat, 20 Okt pukul 14:00 via Zoom."},
                  ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["Semua", "Aktif", "Selesai"].asMap().entries.map((e) {
          return Obx(() => ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(e.value, style: TextStyle(color: controller.filterIndex.value == e.key ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold)),
            ),
            selected: controller.filterIndex.value == e.key,
            onSelected: (val) => controller.changeFilter(e.key),
            selectedColor: const Color(0xFF2170E4),
            backgroundColor: Colors.grey[100],
            elevation: 0,
            pressElevation: 0,
          ));
        }).toList(),
      ),
    );
  }

  Widget _buildUpdateAlert() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.goToInterview(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD), 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Row(
            children: [
              // Ikon Kalender
              Container(
                padding: const EdgeInsets.all(8), 
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                ), 
                child: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              // Teks Informasi
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(
                      "Update Terkini", 
                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "2 Jadwal Wawancara Mendatang", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Badge Angka Notifikasi
              const CircleAvatar(
                radius: 10, 
                backgroundColor: Colors.blue, 
                child: Text(
                  "1", 
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobStatusCard({required String title, required String company, required String location, required int match, required String status, required List<Map<String, dynamic>> activities}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.grey[100]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(company, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(location, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ])),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("STATUS SAAT INI", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text("MATCH SCORE", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("$match%", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2170E4))),
              ]),
            ],
          ),
          const SizedBox(height: 24),
          const Row(children: [Icon(Icons.history, size: 16, color: Colors.grey), SizedBox(width: 8), Text("Riwayat Aktivitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
          const SizedBox(height: 20),
          ...activities.asMap().entries.map((e) => _buildTimelineStep(e.value, isLast: e.key == activities.length - 1)).toList(),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[50], elevation: 0, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Lihat Detail Lowongan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)), Icon(Icons.chevron_right, color: Colors.black, size: 18)]),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> data, {required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data['isDone'] ? Colors.blue : Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: data['isDone'] ? const Icon(Icons.check, size: 14, color: Colors.white) : const Center(child: CircleAvatar(radius: 4, backgroundColor: Colors.blue)),
            ),
            if (!isLast) Container(width: 2, height: 40, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(data['time'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
          if (data['note'] != null) Padding(padding: const EdgeInsets.only(top: 4, bottom: 12), child: Text(data['note'], style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic))),
          if (data['note'] == null) const SizedBox(height: 24),
        ]))
      ],
    );
  }
}