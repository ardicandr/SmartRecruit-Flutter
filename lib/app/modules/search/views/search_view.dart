import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/search_controller.dart';
import '../../../data/providers/api_provider.dart';

class SearchView extends GetView<AppSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterSection(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final jobs = controller.filteredJobs;
                
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    _buildResultCount(jobs.length),
                    _buildAiBanner(), // Banner AI Recommendation
                    if (jobs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: Text("Tidak ada lowongan yang sesuai")),
                      )
                    else
                      ...jobs.map((job) => _buildJobItem(
                        job['title'] ?? 'Unknown',
                        job['company_name'] ?? 'Unknown Company',
                        "New",
                        job['salary_range'] ?? 'Tidak ditampilkan',
                        job['company_logo'],
                      )),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Get.back(), 
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
        ),
          Expanded(
          child: TextField(
            autofocus: true,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari posisi, skill...",
              prefixIcon: Icon(Icons.search),
                filled: true, fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    List<String> filters = ["Remote", "Gaji Tinggi", "Fresh Graduate"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) => Obx(() => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filters[index], style: TextStyle(color: controller.selectedFilter.value == filters[index] ? Colors.white : Colors.black)),
            selected: controller.selectedFilter.value == filters[index],
            onSelected: (_) => controller.changeFilter(filters[index]),
            selectedColor: AppColors.primary,
            backgroundColor: Colors.grey[100],
            checkmarkColor: Colors.white,
          ),
        )),
      ),
    );
  }

  Widget _buildResultCount(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text("Ditemukan $count lowongan kerja", style: TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }

  Widget _buildJobItem(String title, String company, String match, String salary, String? companyLogo) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[100]!), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black, 
                        borderRadius: BorderRadius.circular(8),
                        image: companyLogo != null && companyLogo.isNotEmpty
                            ? DecorationImage(image: NetworkImage('${ApiProvider.hostUrl}$companyLogo'), fit: BoxFit.cover)
                            : null,
                      ),
                      child: (companyLogo == null || companyLogo.isEmpty) ? const Icon(Icons.business, color: Colors.white, size: 20) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(company, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), 
              child: Text(match, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(salary, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
              Text("Lihat Detail >", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAiBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF2170E4), size: 20),
            const SizedBox(width: 8),
            Text("Rekomendasi AI Untukmu", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
          ]),
          const SizedBox(height: 8),
          Obx(() {
            if (!controller.hasUploadedDocs.value) {
              return const Text(
                "Silakan unggah CV atau Sertifikat terlebih dahulu untuk mendapatkan rekomendasi lowongan cerdas dari AI.", 
                style: TextStyle(fontSize: 12, color: Color(0xFF2170E4), height: 1.4)
              );
            }
            return const Text(
              "Berdasarkan profil kamu, AI akan mencarikan lowongan yang memiliki kecocokan tinggi.", 
              style: TextStyle(fontSize: 12, color: Color(0xFF2170E4), height: 1.4)
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.goToAiInsight(), 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2170E4), 
              minimumSize: const Size(double.infinity, 48), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text("Lihat Analisis Detail", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}