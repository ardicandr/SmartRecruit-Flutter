import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<AppSearchController> {
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
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  _buildResultCount(),
                  _buildJobItem("Senior UI/UX", "TechNova Solutions", "98% Match", "Rp 15jt - 22jt"),
                  _buildAiBanner(), // Banner AI Recommendation
                  _buildJobItem("Frontend Engineer", "Creative Pulse", "85% Match", "Rp 12jt - 18jt"),
                  _buildJobItem("Product Manager", "GoGreen App", "72% Match", "Rp 20jt - 30jt"),
                ],
              ),
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
            decoration: InputDecoration(
              hintText: "Cari posisi, skill...",
              prefixIcon: Icon(Icons.search),
                filled: true, fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.tune, color: Colors.white),
          )
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

  Widget _buildResultCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text("Ditemukan 124 lowongan kerja", style: TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }

  Widget _buildJobItem(String title, String company, String match, String salary) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[100]!), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8))),
                  SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(company, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                ],
              ),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), 
              child: Text(match, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(salary, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Lihat Detail >", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAiBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.bolt, color: AppColors.primary),
            SizedBox(width: 8),
            Text("Rekomendasi AI Untukmu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
          ]),
          SizedBox(height: 8),
          Text("Berdasarkan CV kamu, ada 5 lowongan baru yang cocok 90%!", style: TextStyle(fontSize: 12, color: Colors.blue[700])),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text("Lihat Semua", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: Size(double.infinity, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )
        ],
      ),
    );
  }
}