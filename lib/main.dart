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
    // clientId digunakan oleh Web Platform. Di Android JANGAN diisi dengan Web Client ID agar tidak error [16]
    clientId: kIsWeb ? '812605113651-i3v7rkfe0i55oqq49miae1h3gk905m99.apps.googleusercontent.com' : null,
    // serverClientId digunakan oleh Android agar bisa mendapat idToken untuk dikirim ke Flask
    serverClientId: '812605113651-i3v7rkfe0i55oqq49miae1h3gk905m99.apps.googleusercontent.com',
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