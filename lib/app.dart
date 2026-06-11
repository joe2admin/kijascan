import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/core/theme_controller.dart';
import 'package:kijascan/routes/app_pages.dart';
import 'package:kijascan/utils/theme/theme.dart';
import 'package:kijascan/core/events/realtime_events_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    Get.put(ThemeController());
    
    // Initialize RealtimeEventsController
    Get.put(RealtimeEventsController());

    return Obx(() {
      final themeMode = Get.find<ThemeController>().themeMode.value;
      return GetMaterialApp(
        title: 'KijaScan',
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        // GetX Routing Setup
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      );
    });
  }
}
