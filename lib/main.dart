import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/data/providers/api_provider.dart';
import 'app/data/services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Minta izin notifikasi (untuk iOS dan Android 13+)
    await FirebaseMessaging.instance.requestPermission();
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  await initializeDateFormatting('id_ID', null);
  
  // Inisialisasi Google Sign-In (wajib untuk google_sign_in v7.x)
  try {
    await GoogleSignIn.instance.initialize(
      // clientId digunakan oleh Web Platform. Di Android JANGAN diisi dengan Web Client ID agar tidak error [16]
      clientId: kIsWeb ? '812605113651-i3v7rkfe0i55oqq49miae1h3gk905m99.apps.googleusercontent.com' : null,
      // serverClientId digunakan oleh Android agar bisa mendapat idToken untuk dikirim ke Flask
      serverClientId: kIsWeb ? null : '812605113651-i3v7rkfe0i55oqq49miae1h3gk905m99.apps.googleusercontent.com',
    );
  } catch (e) {
    print("GoogleSignIn init error: $e");
  }
  
  Get.put(ApiProvider(), permanent: true); 
  try {
    await Get.putAsync(() => NotificationService().init());
  } catch (e) {
    print("NotificationService init error: $e");
  }

  // Cek sesi login
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');
  String initialRoute = token != null ? Routes.HOME : Routes.ONBOARDING;

  runApp(
    GetMaterialApp(
      title: "SmartRecruit",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}