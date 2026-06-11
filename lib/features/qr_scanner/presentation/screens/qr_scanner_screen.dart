import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/qr_scanner_controller.dart';
import '../widgets/scanner_viewport_overlay.dart';

class QrScannerScreen extends GetView<QrScannerController> {
  const QrScannerScreen({super.key});

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
              ],
            ),
          ),
          // Scan hint positioned just above the bottom nav bar
          Positioned(
            bottom: 116, // Added a little more space above the bottom nav bar
            left: 0,
            right: 0,
            child: const Center(
              child: _ScanHint(),
            ),
          ),
          // Manual entry FAB — positioned above the scan hint to avoid overlapping
          Positioned(
            bottom: 130, 
            right: 24,
            child: SafeArea(
              top: false,
              child: _GlassIconButton(
                icon: Iconsax.keyboard,
                onTap: () => _ManualEntryModal.show(controller),
                tooltip: 'Enter ID manually',
              ),
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
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.light,
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
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
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

  const _TopBar({required this.onTorch, required this.isTorchOn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KijaScan',
                  style: TextStyle(
                    color: TColors.softGrey,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Employee check-in',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 14,
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
  final String? tooltip;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: TSizes.xs * 2,
            height: TSizes.xs * 2,
            decoration: const BoxDecoration(
              color: TColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Flexible(
            child: Text(
              'Point at the employee QR code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: TSizes.fontSizeSm,
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

// ── Manual Entry Modal ────────────────────────────────────────────────────────

class _ManualEntryModal {
  static void show(QrScannerController controller) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isSubmitting = false.obs;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ManualEntrySheet(
        textController: textController,
        formKey: formKey,
        isSubmitting: isSubmitting,
        onSubmit: () async {
          if (!formKey.currentState!.validate()) return;
          if (isSubmitting.value) return;

          isSubmitting.value = true;
          Navigator.of(Get.context!).pop(); // close modal
          await controller.openCheckIn(textController.text.trim());
          isSubmitting.value = false;
        },
      ),
    );
  }
}

class _ManualEntrySheet extends StatelessWidget {
  final TextEditingController textController;
  final GlobalKey<FormState> formKey;
  final RxBool isSubmitting;
  final VoidCallback onSubmit;

  const _ManualEntrySheet({
    required this.textController,
    required this.formKey,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = dark ? TColors.darkContainer : Colors.white;
    final labelColor = dark ? Colors.white70 : Colors.black54;
    final inputBg = dark ? TColors.dark : const Color(0xFFF4F4F4);
    final textColor = dark ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: (dark ? Colors.white : Colors.black).withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Enter Employee ID',
                style: TextStyle(
                  color: textColor,
                  fontSize: TSizes.fontSizeXl,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Use this when the QR code can't be scanned.",
                style: TextStyle(
                  color: labelColor,
                  fontSize: TSizes.fontSizeSm,
                ),
              ),
              const SizedBox(height: 24),

              // Input field
              TextFormField(
                controller: textController,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onSubmit(),
                style: TextStyle(
                  color: textColor,
                  fontSize: TSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. EMP-0042',
                  hintStyle: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: inputBg,
                  prefixIcon: const Icon(
                    Iconsax.user,
                    color: TColors.primary,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: TColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: TColors.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: TColors.error,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an employee ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSubmitting.value ? null : onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: TColors.primary.withValues(
                        alpha: 0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isSubmitting.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Look Up Employee',
                            style: TextStyle(
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
