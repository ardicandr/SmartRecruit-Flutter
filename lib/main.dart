import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "SmartRecruit",
      initialRoute: Routes.ONBOARDING,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}