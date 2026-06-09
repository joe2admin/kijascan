import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: TColors.primary.withValues(alpha: 0.4),
      foregroundColor: Colors.white, //color of the text
      backgroundColor: TColors.primary,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.white,
      side: const BorderSide(color: Colors.transparent),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );

  /// - Dark Themes
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 4,
      shadowColor: TColors.primary.withValues(alpha: 0.6),
      foregroundColor: Colors.white,
      backgroundColor: TColors.primary,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.white,
      side: const BorderSide(color: Colors.transparent),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
