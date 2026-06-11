import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/main_shell/controllers/main_shell_controller.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class QrScannerController extends GetxController with WidgetsBindingObserver {
  late final MobileScannerController cameraController;

  var isScanning = true.obs;
  var isTorchOn = false.obs;
  var hasCameraPermission = false.obs;
  var cameraError = RxnString();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false,
    );
  }

  @override
  void onReady() {
    super.onReady();
    if (_isScanTabActive) {
      initializeCamera();
    }
  }

  bool get _isScanTabActive {
    if (!Get.isRegistered<MainShellController>()) return true;
    return Get.find<MainShellController>().currentIndex.value == 1;
  }

  Future<void> pauseCamera() => cameraController.stop();

  Future<void> resumeCamera() async {
    if (_isScanTabActive && isScanning.value) {
      await initializeCamera();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (Get.currentRoute == AppRoutes.main &&
          _isScanTabActive &&
          isScanning.value) {
        initializeCamera();
      }
    } else if (state == AppLifecycleState.paused) {
      cameraController.stop();
    }
  }

  Future<void> initializeCamera() async {
    cameraError.value = null;

    final granted = await _requestCameraPermission();
    hasCameraPermission.value = granted;

    if (!granted) {
      cameraError.value = 'Camera permission is required to scan QR codes.';
      return;
    }

    try {
      if (!cameraController.value.isRunning) {
        await cameraController.start();
      }
    } on MobileScannerException catch (e) {
      cameraError.value = scannerErrorMessage(e);
    } catch (e) {
      cameraError.value = 'Could not start the camera. Please try again.';
    }
  }

  Future<bool> _requestCameraPermission() async {
    var status = await perm.Permission.camera.status;

    if (status.isDenied || status.isRestricted) {
      status = await perm.Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return status.isGranted;
  }

  String scannerErrorMessage(MobileScannerException error) {
    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        return 'Camera permission was denied. Enable it in Settings.';
      case MobileScannerErrorCode.unsupported:
        return 'Camera scanning is not supported on this device.';
      case MobileScannerErrorCode.controllerUninitialized:
        return 'Camera is still starting. Please wait…';
      default:
        return error.errorDetails?.message ?? 'Camera failed to start.';
    }
  }

  Future<void> toggleTorch() async {
    await cameraController.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  Future<void> goToAppSettings() => perm.openAppSettings();

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.onClose();
  }

  void onDetect(BarcodeCapture capture) {
    if (!isScanning.value) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      HapticFeedback.vibrate();
      openCheckIn(barcodes.first.rawValue!);
    }
  }

  Future<void> openCheckIn(String rawPayload) async {
    if (!isScanning.value) return;

    isScanning.value = false;

    await Get.toNamed(
      AppRoutes.checkIn,
      arguments: rawPayload,
    );

    await resetScanner();
  }

  Future<void> resetScanner() async {
    isScanning.value = true;
    if (_isScanTabActive) {
      await initializeCamera();
    }
  }
}
