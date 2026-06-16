import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';

class AiInsightController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  
  var origin = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var profileScores = <String, double>{
    "Pengalaman": 0.0,
    "Skill Teknis": 0.0,
    "Sertifikasi": 0.0,
    "Pendidikan": 0.0,
    "Portofolio": 0.0,
  }.obs;

  var overallScore = 0.obs;
  var analysisItems = <dynamic>[].obs;
  var careerRecommendations = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      origin.value = Get.arguments.toString();
    }
    fetchAiAnalysis();
  }

  Future<void> fetchAiAnalysis() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print("=== AI INSIGHT: Memanggil API /ai/analyze-profile ===");
      
      final response = await apiProvider.getAiAnalysis();
      
      print("=== AI INSIGHT: Status Code = ${response.statusCode} ===");
      print("=== AI INSIGHT: Body = ${response.body} ===");
      
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        
        if (data is Map<String, dynamic>) {
          overallScore.value = (data['overall_score'] ?? 0).toInt();
          
          if (data['scores'] != null && data['scores'] is Map) {
            profileScores.value = {
              "Pengalaman": _toDouble(data['scores']['Pengalaman']),
              "Skill Teknis": _toDouble(data['scores']['Skill Teknis']),
              "Sertifikasi": _toDouble(data['scores']['Sertifikasi']),
              "Pendidikan": _toDouble(data['scores']['Pendidikan']),
              "Portofolio": _toDouble(data['scores']['Portofolio']),
            };
          }
          
          if (data['analysis_items'] != null && data['analysis_items'] is List) {
            analysisItems.assignAll(data['analysis_items']);
          }
          
          if (data['career_recommendations'] != null && data['career_recommendations'] is List) {
            careerRecommendations.assignAll(
              List<String>.from(data['career_recommendations'].map((e) => e.toString()))
            );
          }
          
          print("=== AI INSIGHT: Parse berhasil! Score = ${overallScore.value} ===");
        } else {
          errorMessage.value = "Format respons tidak dikenali";
          print("=== AI INSIGHT: Body bukan Map! Tipe: ${data.runtimeType} ===");
        }
      } else if (response.statusCode == 400 && response.body != null && response.body['message'] != null) {
        errorMessage.value = response.body['message'];
        print("=== AI INSIGHT: Tidak ada dokumen! ===");
      } else {
        errorMessage.value = "Server merespon: ${response.statusCode}";
        print("=== AI INSIGHT: Gagal! status=${response.statusCode}, body=${response.body} ===");
      }
    } catch (e, stackTrace) {
      errorMessage.value = "Gagal mengambil data: $e";
      print("=== AI INSIGHT ERROR: $e ===");
      print("=== STACKTRACE: $stackTrace ===");
    } finally {
      isLoading.value = false;
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void handleBack() {
    Get.back();
  }
}