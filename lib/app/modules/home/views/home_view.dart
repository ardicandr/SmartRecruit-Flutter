import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../status/views/status_view.dart';
import '../../profile/views/profile_view.dart';
import '../../saved_jobs/views/saved_jobs_view.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              _buildMainHome(),
              StatusView(),
              SavedJobsView(),
              ProfileView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMainHome() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomAppBar(),
            _buildGreeting(),
            _buildSearchBar(),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Rekomendasi Spesial"), 
            
            _buildHorizontalList(),
            const SizedBox(height: 32),
            
            _buildSectionTitleWithToggle("Lowongan Terbaru"),
            
            _buildVerticalList(),
            const SizedBox(height: 20),
          ],
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text("SmartRecruit", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const Spacer(),
          
          IconButton(
            onPressed: () => controller.goToNotifications(), 
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18, 
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=a")
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Halo, Budi! 👋", style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          const SizedBox(height: 4),
          const Text("Temukan pekerjaan impianmu hari ini.", style: TextStyle(color: AppColors.textGray, fontSize: 14)),
        ],
      ),
    );
  }

    Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24, top: 12),
        itemCount: controller.specialJobs.length,
        itemBuilder: (context, index) {
          var job = controller.specialJobs[index];
          return Container(
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
                    const CircleAvatar(backgroundColor: Colors.white, radius: 20, child: Icon(Icons.business, color: Colors.amber)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Text("HOT JOB", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 9)),
                    )
                  ],
                ),
                const Spacer(),
                Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(job['company'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [const Icon(Icons.location_on, size: 10, color: Colors.blue), Text(job['location'], style: const TextStyle(fontSize: 10, color: Colors.blue))]),
                    ),
                    Text(job['salary'], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: controller.latestJobs.length,
      itemBuilder: (context, index) {
        var job = controller.latestJobs[index];
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
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(job['company'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Row(children: [
                    const Icon(Icons.bolt, color: Colors.purple, size: 16),
                    Text(job['match'], style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  ])
                ],
              ),
              const SizedBox(height: 16),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[400]),
                Text(" ${job['location']}", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.monetization_on_outlined, size: 14, color: Colors.grey[400]),
                Text(" ${job['salary']}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
              const SizedBox(height: 12),
              Row(children: (job['tags'] as List).map((tag) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              )).toList()),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(job['posted'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
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