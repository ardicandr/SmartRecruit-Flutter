import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/status_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/providers/api_provider.dart';
import 'package:intl/intl.dart';
import '../../notification/controllers/notification_controller.dart';

class StatusView extends GetView<StatusController> {
  const StatusView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Status Lamaran",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF2170E4),
            fontWeight: FontWeight.w800,
            fontSize: 24,
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(() {
              final home = Get.find<HomeController>();
              if (home.profileImageUrl.value.isNotEmpty) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(home.profileImageUrl.value),
                  backgroundColor: Colors.blue,
                );
              } else if (home.localImagePath.value.isNotEmpty) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: FileImage(File(home.localImagePath.value)),
                  backgroundColor: Colors.blue,
                );
              } else {
                return const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                );
              }
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Obx(() {
            var upcomingInterviews = controller.myApplications
                .where(
                  (app) =>
                      app['status'] == 'Interview' &&
                      app['interview_date'] != null,
                )
                .toList();

            if (upcomingInterviews.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: _buildUpdateAlert(upcomingInterviews),
              );
            }
            return const SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var filteredApps = controller.filteredApplications;

              if (filteredApps.isEmpty) {
                return const Center(child: Text("Belum ada lamaran terkirim"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  var app = filteredApps[index];
                  String currentStatus = app['status'];
                  List<Map<String, dynamic>> activities = [
                    {
                      "title": "Lamaran Terkirim",
                      "time": app['applied_at'],
                      "isDone": true,
                    },
                  ];

                  String updatedAt = app['updated_at'] ?? '-';

                  // Format interview date if exists
                  String interviewDateStr = "-";
                  if (app['interview_date'] != null) {
                    try {
                      DateTime dt = DateTime.parse(app['interview_date']);
                      interviewDateStr =
                          "${dt.day} ${_getMonth(dt.month)} ${dt.year}";
                    } catch (e) {}
                  }

                  if (currentStatus == 'Submitted') {
                    activities.add({
                      "title": "Review oleh HRD",
                      "time": "-",
                      "isDone": false,
                    });
                  } else if (currentStatus == 'Interview') {
                    activities.add({
                      "title": "Review oleh HRD",
                      "time": updatedAt,
                      "isDone": true,
                    });
                    activities.add({
                      "title": "Jadwal Interview",
                      "time": interviewDateStr,
                      "isDone": false,
                      "note": "HRD telah mengundang Anda untuk interview.",
                    });
                  } else if (currentStatus == 'Accepted') {
                    activities.add({
                      "title": "Review oleh HRD",
                      "time":
                          app['applied_at'], // Perkiraan tanggal selesai review
                      "isDone": true,
                    });
                    activities.add({
                      "title": "Wawancara",
                      "time": interviewDateStr != "-"
                          ? interviewDateStr
                          : app['applied_at'],
                      "isDone": true,
                    });
                    activities.add({
                      "title": "Diterima Bekerja!",
                      "time": updatedAt,
                      "isDone": true,
                      "note": "Selamat! Anda dinyatakan lolos.",
                      "color": Colors.green,
                    });
                  } else if (currentStatus == 'Rejected') {
                    activities.add({
                      "title": "Review oleh HRD",
                      "time":
                          app['applied_at'], // Perkiraan tanggal selesai review
                      "isDone": true,
                    });
                    activities.add({
                      "title": "Keputusan Akhir",
                      "time": updatedAt,
                      "isDone": true,
                      "note": "Maaf, lamaran Anda belum dapat dilanjutkan.",
                      "color": Colors.red,
                    });
                  } else {
                    activities.add({
                      "title": "Review oleh HRD",
                      "time": updatedAt,
                      "isDone": true,
                    });
                  }

                  return _buildJobStatusCard(
                    title: app['job_title'],
                    company: app['company'],
                    location: app['location'],
                    match: (app['match_score'] as double).toInt(),
                    status: app['status'],
                    activities: activities,
                    jobData: app,
                    companyLogo: app['company_logo'],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return month >= 1 && month <= 12 ? months[month - 1] : '';
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["Semua", "Aktif", "Selesai"].asMap().entries.map((e) {
          return Obx(
            () => ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  e.value,
                  style: TextStyle(
                    color: controller.filterIndex.value == e.key
                        ? Colors.white
                        : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              selected: controller.filterIndex.value == e.key,
              onSelected: (val) => controller.changeFilter(e.key),
              selectedColor: const Color(0xFF2170E4),
              backgroundColor: Colors.grey[100],
              elevation: 0,
              pressElevation: 0,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpdateAlert(List<dynamic> upcomingInterviews) {
    if (upcomingInterviews.isEmpty) return const SizedBox.shrink();
    var latestInterview = upcomingInterviews.first;

    // Format tanggal sederhana, asumsi 'interview_date' berupa ISO-8601 string
    String dateRaw = latestInterview['interview_date'] ?? '';
    String dateFormatted = dateRaw;
    try {
      DateTime dt = DateTime.parse(dateRaw);
      dateFormatted = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (e) {}

    String type = latestInterview['interview_type'];

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
                child: Icon(
                  type == 'Online' ? Icons.video_call : Icons.calendar_today,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Teks Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Panggilan Interview",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${latestInterview['job_title']} - $dateFormatted",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge Angka Notifikasi jika lebih dari 1
              if (upcomingInterviews.length > 1)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: Text(
                    "${upcomingInterviews.length}",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobStatusCard({
    required String title,
    required String company,
    required String location,
    required int match,
    required String status,
    required List<Map<String, dynamic>> activities,
    required Map<String, dynamic> jobData,
    String? companyLogo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  image: companyLogo != null && companyLogo.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            '${ApiProvider.hostUrl}$companyLogo',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (companyLogo == null || companyLogo.isEmpty)
                    ? const Icon(Icons.business, color: Colors.white, size: 24)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      company,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "STATUS SAAT INI",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "MATCH SCORE",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "$match%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2170E4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(Icons.history, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                "Riwayat Aktivitas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...activities.asMap().entries.map(
            (e) => _buildTimelineStep(
              e.value,
              isLast: e.key == activities.length - 1,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => controller.goToJobDetail(jobData),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[50],
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lihat Detail Lowongan",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.black, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> data, {required bool isLast}) {
    Color stepColor = data['color'] ?? Colors.blue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data['isDone'] ? stepColor : Colors.white,
                border: Border.all(color: stepColor, width: 2),
              ),
              child: data['isDone']
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: stepColor,
                      ),
                    ),
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                data['time'],
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              if (data['note'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    data['note'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (data['note'] == null) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
