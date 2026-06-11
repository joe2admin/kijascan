import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/main_shell/controllers/main_shell_controller.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class CheckInSuccessScreen extends StatelessWidget {
  const CheckInSuccessScreen({super.key});

  static const Color _green = TColors.primary;
  static const Color _darkBg = TColors.dark;

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
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final message = args['message'] as String? ?? 'Attendance recorded.';
    final employeeName = args['employeeName'] as String? ?? 'Employee';
    final checkedInTime = args['checkedInTime'] as String?;
    final date = args['date'] as String?;
    final isClockOut = args['isClockOut'] as bool? ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _darkBg : const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isClockOut ? Icons.logout_rounded : Icons.login_rounded, 
                  color: _green, 
                  size: 40
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isClockOut ? 'Clock-Out Successful' : 'Clock-In Successful',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F1A12),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                employeeName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (checkedInTime != null) ...[
                const SizedBox(height: 20),
                Text(
                  isClockOut ? 'Clocked out at $checkedInTime' : 'Clocked in at $checkedInTime',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (date != null) ...[
                const SizedBox(height: 4),
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 13,
                  ),
                ),
              ],
              const Spacer(flex: 3),
              _PrimaryButton(label: 'Scan Another', onTap: _returnToScanner),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _returnToScanner,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
          color: TColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: TColors.primary.withValues(alpha: 0.3),
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
