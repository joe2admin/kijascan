// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KijaScan',
      debugShowCheckedModeBanner: false,

      // GetX Routing Setup
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // You can also link your core/theme/ UI settings here later
      // theme: AppTheme.lightTheme,
    );
  }
}
