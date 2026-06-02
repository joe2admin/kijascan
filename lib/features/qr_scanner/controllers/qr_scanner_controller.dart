import 'package:get/get.dart';

class QrScannerController extends GetxController {
  // Observable states
  var isScanning = true.obs;
  var isLoading = false.obs;
  var scanResult = ''.obs;
  var statusMessage = ''.obs;

  /// Simulates processing the QR payload with a Laravel backend
  Future<void> processQRData(String rawPayload) async {
    if (isLoading.value) return;

    isScanning.value = false;
    isLoading.value = true;
    scanResult.value = rawPayload;
    statusMessage.value = "Sending data to backend...";

    // Simulate network latency (mimicking a future HTTP post to Laravel)
    await Future.delayed(const Duration(seconds: 2));

    // Mocking a successful response from a Laravel API
    // e.g., validation successful, attendance recorded
    isLoading.value = false;
    statusMessage.value = "Check-in successful! Welcome back.";
  }

  /// Resets the scanner state to scan a new code
  void resetScanner() {
    isScanning.value = true;
    scanResult.value = '';
    statusMessage.value = '';
  }
}