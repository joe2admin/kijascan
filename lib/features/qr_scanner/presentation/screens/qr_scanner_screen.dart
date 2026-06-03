import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/qr_scanner_controller.dart';
import '../widgets/scanner_viewport_overlay.dart';

class QrScannerScreen extends GetView<QrScannerController> {
  const QrScannerScreen({super.key});

  static const Color _green = Color(0xFF22C55E);

  static const double _scanWindowSize = 300;

  static Rect _scanWindow(Size size) {
    return Rect.fromCenter(
      center: size.center(const Offset(0, -32)),
      width: _scanWindowSize,
      height: _scanWindowSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final scanWindow = _scanWindow(screenSize);

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
            MobileScanner(
              controller: controller.cameraController,
              fit: BoxFit.cover,
              scanWindow: scanWindow,
              onDetect: controller.onDetect,
              errorBuilder: (context, error, child) {
                return _CameraErrorView(
                  message: controller.scannerErrorMessage(error),
                  onRetry: controller.initializeCamera,
                  onSettings: controller.goToAppSettings,
                );
              },
              overlayBuilder: (context, constraints) {
                return ValueListenableBuilder<MobileScannerState>(
                  valueListenable: controller.cameraController,
                  builder: (context, state, _) {
                    if (!state.isInitialized ||
                        !state.isRunning ||
                        state.error != null) {
                      return const SizedBox.shrink();
                    }
                    return ScannerViewportOverlay(scanWindow: scanWindow);
                  },
                );
              },
            ),
            Obx(() {
              final message = controller.cameraError.value;
              if (message == null || controller.hasCameraPermission.value) {
                return const SizedBox.shrink();
              }
              return _CameraErrorView(
                message: message,
                onRetry: controller.initializeCamera,
                onSettings: controller.goToAppSettings,
              );
            }),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _TopBar(
                    onTorch: controller.toggleTorch,
                    isTorchOn: controller.isTorchOn,
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _ScanHint(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSettings;

  const _CameraErrorView({
    required this.message,
    required this.onRetry,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.no_photography_outlined,
                color: Colors.white.withValues(alpha: 0.7),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: QrScannerScreen._green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                child: const Text('Try again'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onSettings,
                child: Text(
                  'Open Settings',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onTorch;
  final RxBool isTorchOn;

  const _TopBar({
    required this.onTorch,
    required this.isTorchOn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KijaScan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Employee check-in',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => _GlassIconButton(
              icon: isTorchOn.value
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              onTap: onTorch,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _ScanHint extends StatelessWidget {
  const _ScanHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: QrScannerScreen._green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Point at the employee QR code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
