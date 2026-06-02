import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/data/providers/api_provider.dart';

void main() {
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