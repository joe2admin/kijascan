import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/routes/app_pages.dart';
import 'package:kijascan/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KijaScan',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      // GetX Routing Setup
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
