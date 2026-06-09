import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/utils/constants/colors.dart';

class CustomSnackbar {
  static void showSuccess({required String title, required String message}) {
    _showSnackbar(title: title, message: message, isError: false);
  }

  static void showError({required String title, required String message}) {
    _showSnackbar(title: title, message: message, isError: true);
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required bool isError,
  }) {
    final context = Get.context;
    if (context == null) return;

    final dark = Theme.of(context).brightness == Brightness.dark;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: dark ? TColors.darkContainer : TColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 250), // Faster animation
      icon: Icon(
        isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
        color: isError ? TColors.error : TColors.primary,
        size: 24,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        )
      ],
      titleText: Text(
        title,
        style: TextStyle(
          color: dark ? TColors.white : TColors.black,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: dark ? TColors.softGrey : TColors.darkerGrey,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      mainButton: TextButton(
        onPressed: () => Get.closeCurrentSnackbar(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(40, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Icon(
          Icons.close_rounded,
          color: dark ? TColors.darkGrey : TColors.darkerGrey,
          size: 20,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
