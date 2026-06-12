import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiProvider extends GetConnect {
  final storage = const FlutterSecureStorage();

  static const String hostUrl = "http://10.164.225.225:5000";
  final String baseUrlStr = "$hostUrl/api";

  ApiProvider() {
    baseUrl = baseUrlStr;
    // Timeout
    timeout = const Duration(seconds: 20);
  }

  @override
  void onInit() {
    baseUrl = baseUrlStr;
    // Set timeout to 120 seconds explicitly on the HTTP client
    httpClient.timeout = const Duration(seconds: 120);
    
    httpClient.addRequestModifier<dynamic>((request) async {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt_token');
      
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print("TOKEN TERKIRIM: $token");
      } else {
        print("TOKEN TIDAK DITEMUKAN DI STORAGE");
      }
      return request;
    });
    super.onInit();
  }

  // --- JOBS ---
  
  Future<Response> getJobs() => get("/jobs/explore");

  Future<Response> getJobDetail(int id) => get("/jobs/$id");

  Future<Response> applyJob(int jobId) {
    return post(
      "/jobs/$jobId/apply",
      {"job_id": jobId},
    );
  }

 
  Future<Response> getMyApplications() => get("/my-applications");

  // --- REGISTER
  Future<Response> registerPelamar(String username, String email, String password) {

    final form = FormData({
      'username': username,
      'email': email,
      'password': password,
      'role': 'Pelamar',
    });
    
    return post("/auth/register", form);
  }

  // --- LOGIN ---
  Future<Response> loginRequest(String email, String password) {
    return post(
      "/auth/login", 
      {
        "email": email,
        "password": password,
      },
    );
  }

  // --- GOOGLE OAUTH ---
  Future<Response> postGoogleAuth(String idToken) {
    return post(
      "/auth/google",
      {
        "idToken": idToken,
      },
    );
  }

  Future<Response> deleteCertificate(int id) => delete("/certificates/$id");

  // ============================================
  // BOOKMARK ENDPOINTS
  // ============================================
  Future<Response> getBookmarks() async {
    final token = await storage.read(key: 'jwt_token');
    return get(
      "/bookmarks",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> toggleBookmark(int jobId, bool isAdding) async {
    final token = await storage.read(key: 'jwt_token');
    if (isAdding) {
      return post(
        "/bookmarks/$jobId",
        {},
        headers: {"Authorization": "Bearer $token"},
      );
    } else {
      return delete(
        "/bookmarks/$jobId",
        headers: {"Authorization": "Bearer $token"},
      );
    }
  }

  // ============================================
  // CV UPLOAD & AI OCR ENDPOINTS
  // ============================================
  Future<Response> scanCv(FormData data) async {
    final token = await storage.read(key: 'jwt_token');
    return post(
      "/cv/scan",
      data,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> saveCv(FormData data) async {
    final token = await storage.read(key: 'jwt_token');
    return post(
      "/cv/save",
      data,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> getUserCv() async {
    final token = await storage.read(key: 'jwt_token');
    return get(
      "/profile/cv",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ============================================
  // AI INSIGHT (PROFILE ANALYSIS) ENDPOINTS
  // ============================================
  Future<Response> getAiAnalysis() async {
    final token = await storage.read(key: 'jwt_token');
    print("=== API PROVIDER: Calling /ai/analyze-profile ===");
    
    return get(
      "/ai/analyze-profile",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ============================================
  // AI JOB MATCH SCORE DYNAMIC
  // ============================================
  Future<Response> getJobMatchScore(int jobId) async {
    final token = await storage.read(key: 'jwt_token');
    return get(
      "/jobs/$jobId/match-score",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}