import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/main_shell/controllers/main_shell_controller.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class CheckInErrorView extends StatelessWidget {
  final String errorMessage;

  const CheckInErrorView({super.key, required this.errorMessage});

  static const Color _red = TColors.error;

  static void _returnToScanner() {
    Get.until((route) => route.settings.name == AppRoutes.main);
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().goToScanTab();
    }
    if (Get.isRegistered<QrScannerController>()) {
      Get.find<QrScannerController>().resetScanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _red.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline_rounded, color: _red, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Scan Failed',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F1A12),
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(flex: 3),
          _PrimaryButton(label: 'Try Again', onTap: _returnToScanner),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _returnToScanner,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontSize: TSizes.fontSizeMd,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: TColors.error,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: TColors.error.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: TSizes.fontSizeMd,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
