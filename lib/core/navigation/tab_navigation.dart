import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/routes/app_routes.dart';

void onMainTabChanged(int index) {
  switch (index) {
    case 0:
      if (Get.currentRoute != AppRoutes.history) {
        Get.offNamed(AppRoutes.history);
      }
      break;
    case 1:
      if (Get.currentRoute != AppRoutes.qrScanner) {
        Get.offNamed(AppRoutes.qrScanner);
      }
      break;
    case 2:
      Get.snackbar(
        'Team',
        'Team view is coming soon.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      break;
  }
}
