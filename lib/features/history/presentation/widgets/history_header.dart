import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  void _onSettingsTapped() {
    // Navigate to settings page
    Get.toNamed('/settings');
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(
                color: dark ? TColors.light : TColors.dark,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Employees who have clocked out',
              style: TextStyle(
                color: dark ? TColors.light : TColors.dark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Settings Icon
        GestureDetector(
          onTap: _onSettingsTapped,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.setting_2,
              color: dark ? TColors.light : TColors.dark,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}