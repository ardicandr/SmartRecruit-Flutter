import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../status/views/status_view.dart';
import '../../profile/views/profile_view.dart';
import '../../saved_jobs/views/saved_jobs_view.dart';
import '../../../data/providers/api_provider.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              _buildMainHome(),
              const StatusView(),
              const SavedJobsView(),
              const ProfileView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMainHome() {
    return SafeArea(
      child: RefreshIndicator( // Tambahkan ini agar bisa tarik layar untuk refresh
        onRefresh: () async => controller.fetchJobs(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomAppBar(),
              _buildGreeting(),
              _buildSearchBar(),
              const SizedBox(height: 16),
              
              // TREN LOWONGAN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/trend'),
                  icon: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                  label: const Text(
                    "Tren Lowongan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle("Rekomendasi Spesial"), 
              Obx(() => controller.isLoading.value 
                ? const Center(child: CircularProgressIndicator()) 
                : _buildHorizontalList()),
              
              const SizedBox(height: 32),
              
              _buildSectionTitleWithToggle("Lowongan Terbaru"),
              Obx(() => controller.isLoading.value 
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )) 
                : _buildVerticalList()),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/icon_aplikasi.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Text("SmartRecruit", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const Spacer(),
          
          IconButton(
            onPressed: () => controller.goToNotifications(), 
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          
          const SizedBox(width: 16),
          Obx(() {
            if (controller.profileImageUrl.value.isNotEmpty) {
              return CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(controller.profileImageUrl.value),
                backgroundColor: AppColors.primary,
              );
            } else if (controller.localImagePath.value.isNotEmpty) {
              return CircleAvatar(
                radius: 18,
                backgroundImage: FileImage(controller.localImageFile!),
                backgroundColor: AppColors.primary,
              );
            } else {
              return const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Obx(() => AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: controller.showGreeting.value ? 1.0 : 0.0,
        child: controller.showGreeting.value
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo, ${controller.userName.value}! 👋",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Temukan pekerjaan impianmu hari ini.",
                      style: TextStyle(color: AppColors.textGray, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    ));
  }

  Widget _buildSearchBar() {
    return Obx(() => AnimatedPadding(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: EdgeInsets.fromLTRB(
        24,
        controller.showGreeting.value ? 24 : 16,
        24,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: true,
              onTap: () => controller.goToSearch(),
              decoration: InputDecoration(
                hintText: "Cari posisi, perusahaan, atau skill...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHorizontalList() {
    if (!controller.hasCvOrSkills.value) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Column(
          children: [
            const Icon(Icons.assignment_ind_outlined, color: Colors.orange, size: 40),
            const SizedBox(height: 12),
            const Text("Profil Belum Lengkap", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text(
              "Upload CV agar mendapatkan rekomendasi sesuai dengan keahlian Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.changeTabIndex(3), // Pergi ke tab Profil
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Lengkapi Profil Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    if (controller.specialJobs.isEmpty) return const Center(child: Text("Tidak ada lowongan"));
    
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24, top: 12),
        itemCount: controller.specialJobs.length,
        itemBuilder: (context, index) {
          final job = controller.specialJobs[index];
          return GestureDetector(
            onTap: () => controller.goToDetail(job),
            child: Container(
              width: 260,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      job.companyLogo != null && job.companyLogo!.isNotEmpty
                          ? CircleAvatar(backgroundColor: Colors.white, radius: 20, backgroundImage: NetworkImage('${ApiProvider.hostUrl}${job.companyLogo}'))
                          : const CircleAvatar(backgroundColor: Colors.white, radius: 20, child: Icon(Icons.business, color: Colors.blue)),
                      if (job.matchScore != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.bolt, color: Colors.purple, size: 12),
                              Text(" ${job.matchScore}% Match", style: const TextStyle(color: Colors.purple, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(job.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(job.company ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(job.location ?? "", style: const TextStyle(fontSize: 10, color: Colors.blue)),
                      ),
                      Flexible(
                        child: Text(job.salary ?? "", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalList() {
    if (controller.latestJobs.isEmpty) return const Center(child: Text("Belum ada lowongan terbaru"));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: controller.latestJobs.length,
      itemBuilder: (context, index) {
        final job = controller.latestJobs[index];
        return GestureDetector(
          onTap: () => controller.goToDetail(job),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48, height: 48, 
                      decoration: BoxDecoration(
                        color: Colors.blue[50], 
                        borderRadius: BorderRadius.circular(12),
                        image: job.companyLogo != null && job.companyLogo!.isNotEmpty
                            ? DecorationImage(image: NetworkImage('${ApiProvider.hostUrl}${job.companyLogo}'), fit: BoxFit.cover)
                            : null,
                      ),
                      child: (job.companyLogo == null || job.companyLogo!.isEmpty) ? const Icon(Icons.work_outline, color: Colors.blue) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(job.company ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (job.matchScore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.purple, size: 12),
                            Text(" ${job.matchScore}%", style: const TextStyle(color: Colors.purple, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[400]),
                  Expanded(child: Text(" ${job.location}", style: TextStyle(color: Colors.grey[400], fontSize: 12), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Icon(Icons.monetization_on_outlined, size: 14, color: Colors.grey[400]),
                  Expanded(child: Text(" ${job.salary}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                ]),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job.postedAt ?? "Baru saja", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const Text("Lamar Sekarang >", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                )
              ],
            ),
          )
        );
      },
    );
  }

  // --- HELPERS ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title, 
        style: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: Color(0xFF0B1C30),
        )
      ),
    );
  }

  Widget _buildSectionTitleWithToggle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]), child: const Text("Terbaru", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue))),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Populer", style: TextStyle(fontSize: 10, color: Colors.grey))),
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => BottomNavigationBar(
      currentIndex: controller.tabIndex.value,
      onTap: controller.changeTabIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), 
          activeIcon: Icon(Icons.home), 
          label: "HOME"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history), 
          label: "STATUS"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline), 
          activeIcon: Icon(Icons.bookmark), 
          label: "BOOKMARK"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline), 
          activeIcon: Icon(Icons.person), 
          label: "PROFIL"
        ),
      ],
    ));
  }
}