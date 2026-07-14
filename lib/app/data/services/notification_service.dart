import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../providers/api_provider.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final storage = const FlutterSecureStorage();

  Future<NotificationService> init() async {
    // Meminta izin notifikasi (Penting untuk iOS & Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
      
      // Ambil token FCM
      String? token = await _fcm.getToken();
      if (token != null) {
        print("FCM Token: $token");
        await sendTokenToBackendNow(token);
      }

      // Dengarkan perubahan token (misalnya jika token di-refresh oleh Firebase)
      _fcm.onTokenRefresh.listen((newToken) {
        print("FCM Token Refreshed: $newToken");
        sendTokenToBackendNow(newToken);
      });

      // Tangani pesan saat aplikasi aktif (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          // Tampilkan snackbar atau dialog
          Get.snackbar(
            message.notification?.title ?? "Notifikasi Baru",
            message.notification?.body ?? "",
            duration: const Duration(seconds: 4),
          );
        }
      });
      
    } else {
      print('User declined or has not accepted permission');
    }

    return this;
  }

  Future<void> sendTokenToBackendNow([String? providedToken]) async {
    String? token = providedToken ?? await _fcm.getToken();
    if (token == null) return;
    
    String? jwt = await storage.read(key: 'jwt_token');
    // Hanya kirim jika user sudah login
    if (jwt != null) {
      final api = Get.find<ApiProvider>();
      try {
        final response = await api.sendFcmToken(token);
        if (response.statusCode == 200) {
          print("FCM Token berhasil dikirim ke backend");
        } else {
          print("Gagal mengirim FCM token: ${response.body}");
        }
      } catch (e) {
        print("Error mengirim FCM token: $e");
      }
    }
  }
}
