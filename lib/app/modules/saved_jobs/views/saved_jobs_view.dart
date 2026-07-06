import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/saved_jobs_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/providers/api_provider.dart';

class SavedJobsView extends GetView<SavedJobsController> {
  const SavedJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Lowongan Tersimpan",
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
            // UBAH BAGIAN INI:
            onPressed: () => controller.goToNotifications(), 
            icon: const Icon(Icons.notifications_none, color: Colors.black)
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
          )
        ],
      ),
      body: Obx(() {
        if (controller.savedJobs.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: controller.savedJobs.length,
          itemBuilder: (context, index) {
            final job = controller.savedJobs[index];
            return _buildSavedJobCard(job, index);
          },
        );
      }),
    );
  }

  Widget _buildSavedJobCard(Map<String, dynamic> job, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Perusahaan
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[900], 
                  borderRadius: BorderRadius.circular(16),
                  image: job['company_logo'] != null && job['company_logo'].toString().isNotEmpty
                      ? DecorationImage(image: NetworkImage('${ApiProvider.hostUrl}${job['company_logo']}'), fit: BoxFit.cover)
                      : null,
                ),
                child: (job['company_logo'] == null || job['company_logo'].toString().isEmpty) ? const Icon(Icons.business, color: Colors.white, size: 24) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'], 
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: AppColors.textDark
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['company'], 
                      style: const TextStyle(color: Colors.grey, fontSize: 13)
                    ),
                    Text(
                      job['location'], 
                      style: const TextStyle(color: Colors.grey, fontSize: 11)
                    ),
                  ],
                ),
              ),
              // Tombol Hapus Bookmark
              IconButton(
                onPressed: () => controller.removeBookmark(index),
                icon: const Icon(Icons.bookmark, color: Color(0xFF2170E4), size: 28),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  job['salary'], 
                  style: const TextStyle(
                    color: Color(0xFF2170E4), 
                    fontWeight: FontWeight.w800, 
                    fontSize: 14
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.bolt, 
                    color: job['match'] == "Belum Dianalisis" ? Colors.grey : Colors.purple, 
                    size: 18
                  ),
                  Text(
                    job['match'] == "Belum Dianalisis" ? " Belum Dianalisis" : " ${job['match']} Match", 
                    style: TextStyle(
                      color: job['match'] == "Belum Dianalisis" ? Colors.grey : Colors.purple, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 13
                    )
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle
            ),
            child: Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey[300]),
          ),
          const SizedBox(height: 24),
          Text(
            "Belum ada lowongan disimpan", 
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textDark, 
              fontWeight: FontWeight.bold,
              fontSize: 18
            )
          ),
          const SizedBox(height: 8),
          const Text(
            "Pekerjaan yang Anda simpan akan muncul di sini.", 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}