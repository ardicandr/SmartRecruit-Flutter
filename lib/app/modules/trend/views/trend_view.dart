import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/trend_controller.dart';

class TrendView extends GetView<TrendController> {
  const TrendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          "Tren Lowongan",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(),
            const SizedBox(height: 24),
            _buildAllCategoriesChart(),
            const SizedBox(height: 24),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildCategoryTrendChart(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rentang Waktu",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
              children: [
                _buildFilterChip('today', 'Hari Ini'),
                const SizedBox(width: 8),
                _buildFilterChip('7_days', '7 Hari'),
                const SizedBox(width: 8),
                _buildFilterChip('1_month', '1 Bulan'),
              ],
            )),
        Obx(() {
          if (controller.lastUpdatedMessage.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                controller.lastUpdatedMessage.value,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = controller.selectedFilter.value == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.setFilter(value);
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textGray,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.outline.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lowongan per Kategori",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: Obx(() {
              if (controller.isLoadingAll.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allCategoriesData.isEmpty) {
                return const Center(child: Text("Tidak ada data"));
              }

              final maxTotal = controller.allCategoriesData
                  .map((e) => (e['total'] as num).toDouble())
                  .reduce((a, b) => a > b ? a : b);

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxTotal * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= controller.allCategoriesData.length) {
                            return const SizedBox.shrink();
                          }
                          String cat = controller.allCategoriesData[value.toInt()]['category'].toString();
                          if (cat.length > 5) cat = cat.substring(0, 5) + '...';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              cat,
                              style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxTotal > 0 ? (maxTotal / 4).ceilToDouble() : 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.outline.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    controller.allCategoriesData.length,
                    (i) {
                      final item = controller.allCategoriesData[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (item['total'] as num).toDouble(),
                            color: AppColors.primary,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pilih Kategori untuk Detail",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline.withOpacity(0.5)),
          ),
          child: Obx(() {
            if (controller.categoryList.isEmpty) {
              return const SizedBox(
                height: 48,
                child: Center(child: Text("Tidak ada kategori", style: TextStyle(color: Colors.grey))),
              );
            }
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.selectedCategory.value.isEmpty 
                    ? null 
                    : controller.selectedCategory.value,
                hint: const Text("Pilih kategori"),
                items: controller.categoryList.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) controller.setCategory(val);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryTrendChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                "Tren Harian: ${controller.selectedCategory.value.isNotEmpty ? controller.selectedCategory.value : 'Pilih kategori'}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: Obx(() {
              if (controller.isLoadingCategory.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.categoryTrendData.isEmpty) {
                return const Center(child: Text("Tidak ada data tren"));
              }

              final maxTotal = controller.categoryTrendData
                  .map((e) => (e['total'] as num).toDouble())
                  .reduce((a, b) => a > b ? a : b);

              List<FlSpot> spots = [];
              for (int i = 0; i < controller.categoryTrendData.length; i++) {
                spots.add(FlSpot(i.toDouble(), (controller.categoryTrendData[i]['total'] as num).toDouble()));
              }

              return LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (controller.categoryTrendData.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxTotal * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.orange,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (controller.categoryTrendData.length / 5).ceilToDouble().clamp(1.0, 100.0),
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= controller.categoryTrendData.length) {
                            return const SizedBox.shrink();
                          }
                          String dateStr = controller.categoryTrendData[value.toInt()]['date'].toString();
                          try {
                            DateTime date = DateTime.parse(dateStr);
                            dateStr = DateFormat('dd MMM', 'id_ID').format(date);
                          } catch (e) {
                            // ignore
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              dateStr,
                              style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value != value.toInt()) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxTotal > 0 ? (maxTotal / 4).ceilToDouble() : 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.outline.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
