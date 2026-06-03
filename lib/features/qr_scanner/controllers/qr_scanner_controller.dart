// lib/features/qr_scanner/controllers/qr_scanner_controller.dart

import 'package:get/get.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  var isScanning = true.obs;

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      openCheckIn(barcodes.first.rawValue!);
    }
  }

  Future<void> openCheckIn(String rawPayload) async {
    if (!isScanning.value) return;

    isScanning.value = false;
    await cameraController.stop();

    await Get.toNamed(
      AppRoutes.checkIn,
      arguments: rawPayload,
    );

    resetScanner();
  }

  void resetScanner() {
    isScanning.value = true;
    cameraController.start();
  }
}
