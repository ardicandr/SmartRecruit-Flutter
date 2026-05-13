import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/interview_controller.dart';

class InterviewListView extends GetView<InterviewController> {
  const InterviewListView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        title: Text("Panggilan Wawancara", 
          style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: controller.interviewList.length,
        itemBuilder: (context, index) {
          final item = controller.interviewList[index];
          return _buildInterviewCard(item);
        },
      ),
    );
  }

  Widget _buildInterviewCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => controller.goToDetail(data), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.business, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['role'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(data['company'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(data['isOnline'] ? Icons.videocam_outlined : Icons.location_on_outlined, 
                  color: data['isOnline'] ? Colors.blue : Colors.green),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(data['date'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text("Lihat Detail >", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}