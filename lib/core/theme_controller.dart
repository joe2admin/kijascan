import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with system theme
    themeMode.value = ThemeMode.system;
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      // If system, switch to dark
      themeMode.value = ThemeMode.dark;
    }
  }
}
