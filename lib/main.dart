import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/data/providers/api_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Google Sign-In (wajib untuk google_sign_in v7.x)
  await GoogleSignIn.instance.initialize(
    clientId: kIsWeb ? '747851610367-eb6sbvq4titlb15ru0aha37mmbndpoq1.apps.googleusercontent.com' : null,
    // serverClientId digunakan oleh Android agar bisa mendapat idToken untuk dikirim ke Flask
    serverClientId: kIsWeb ? null : '747851610367-eb6sbvq4titlb15ru0aha37mmbndpoq1.apps.googleusercontent.com',
  );
  
  Get.put(ApiProvider(), permanent: true); 
  runApp(
    GetMaterialApp(
      title: "SmartRecruit",
      initialRoute: Routes.ONBOARDING,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}