import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';

class MainShellController extends GetxController {
  final currentIndex = 1.obs;

  void setTab(int index) {
    if (index == 2) {
      Get.snackbar(
        'Team',
        'Team view is coming soon.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (index == currentIndex.value) return;

    final leavingScan = currentIndex.value == 1;
    currentIndex.value = index;

    if (!Get.isRegistered<QrScannerController>()) return;

    final scanner = Get.find<QrScannerController>();
    if (leavingScan && index == 0) {
      scanner.pauseCamera();
    } else if (index == 1) {
      scanner.resumeCamera();
    }
  }

  void goToScanTab() => setTab(1);
}
