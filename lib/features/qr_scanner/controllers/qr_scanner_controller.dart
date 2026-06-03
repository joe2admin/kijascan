// lib/features/qr_scanner/controllers/qr_scanner_controller.dart

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController extends GetxController {
  // Initialize the native camera controller
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // Prevents firing 100 times a second
    facing: CameraFacing.back,
  );

  var isScanning = true.obs;
  var isLoading = false.obs;
  var scanResult = ''.obs;
  var statusMessage = ''.obs;

  @override
  void onClose() {
    // Crucial: Free up memory when the screen is closed
    cameraController.dispose();
    super.onClose();
  }

  /// Triggers automatically when the camera reads a code
  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value || isLoading.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      processQRData(barcodes.first.rawValue!);
    }
  }

  Future<void> processQRData(String rawPayload) async {
    isScanning.value = false;
    isLoading.value = true;
    scanResult.value = rawPayload;
    statusMessage.value = "Sending data to backend...";

    // Pause the camera feed while we process the mock API call
    cameraController.stop();

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    statusMessage.value = "Check-in successful! Welcome back.";
  }

  void resetScanner() {
    isScanning.value = true;
    scanResult.value = '';
    statusMessage.value = '';
    // Restart the camera feed for the next user
    cameraController.start();
  }
}