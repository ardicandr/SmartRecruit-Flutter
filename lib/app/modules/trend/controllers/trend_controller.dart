import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';

class TrendController extends GetxController {
  final ApiProvider apiProvider = Get.put(ApiProvider());

  final selectedFilter = '1_month'.obs;
  final selectedCategory = ''.obs;

  final isLoadingAll = false.obs;
  final isLoadingCategory = false.obs;

  final allCategoriesData = <Map<String, dynamic>>[].obs;
  final categoryTrendData = <Map<String, dynamic>>[].obs;
  final categoryList = <String>[].obs;

  final lastUpdatedMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    ever(selectedFilter, (_) {
      fetchAllCategories();
      if (selectedCategory.value.isNotEmpty) {
        fetchByCategory();
      }
    });

    ever(selectedCategory, (_) {
      if (selectedCategory.value.isNotEmpty) {
        fetchByCategory();
      }
    });

    fetchAllCategories();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> fetchAllCategories() async {
    isLoadingAll.value = true;
    try {
      final response = await apiProvider.getTrendAllCategories(
        selectedFilter.value,
      );
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body is Map) {
          final List<dynamic> data = body['data'] ?? [];
          allCategoriesData.value = data
              .map((e) => e as Map<String, dynamic>)
              .toList();

          if (body.containsKey('last_updated')) {
            final dateStr = body['last_updated'] ?? '';
            lastUpdatedMessage.value = "Data Terupdate $dateStr";
          } else {
            lastUpdatedMessage.value = "";
          }
        } else {
          final List<dynamic> data = body;
          allCategoriesData.value = data
              .map((e) => e as Map<String, dynamic>)
              .toList();
          lastUpdatedMessage.value = "";
        }

        // Extract unique categories for the dropdown
        final cats = allCategoriesData
            .map((e) => e['category'].toString())
            .toSet()
            .toList();
        categoryList.value = cats;

        // Auto-select first category if current selection is empty or no longer in the list
        if (cats.isNotEmpty) {
          if (selectedCategory.value.isEmpty ||
              !cats.contains(selectedCategory.value)) {
            selectedCategory.value = cats.first;
          }
        } else {
          selectedCategory.value = '';
        }
      } else {
        allCategoriesData.clear();
      }
    } catch (e) {
      print("Error fetching all categories: $e");
      allCategoriesData.clear();
    } finally {
      isLoadingAll.value = false;
    }
  }

  Future<void> fetchByCategory() async {
    if (selectedCategory.value.isEmpty) return;

    isLoadingCategory.value = true;
    try {
      final response = await apiProvider.getTrendByCategory(
        selectedCategory.value,
        selectedFilter.value,
      );
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body is Map) {
          final List<dynamic> data = body['data'] ?? [];
          categoryTrendData.value = data
              .map((e) => e as Map<String, dynamic>)
              .toList();
        } else {
          final List<dynamic> data = body;
          categoryTrendData.value = data
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
      } else {
        categoryTrendData.clear();
      }
    } catch (e) {
      print("Error fetching category trend: $e");
      categoryTrendData.clear();
    } finally {
      isLoadingCategory.value = false;
    }
  }
}
