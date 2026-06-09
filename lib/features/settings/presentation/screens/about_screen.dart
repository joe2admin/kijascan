import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final foregroundColor = dark ? TColors.light : TColors.dark;
    final cardColor = dark ? TColors.black : TColors.white;

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.softGrey,
      appBar: AppBar(
        backgroundColor: dark ? TColors.dark : TColors.light,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Iconsax.arrow_left_2, color: foregroundColor, size: 18),
          ),
        ),
        title: Text(
          'About KijaScan',
          style: TextStyle(
            color: foregroundColor,
            fontSize: TSizes.fontSizeXl,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logos/kijascanlogo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'KijaScan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? TColors.grey : TColors.darkerGrey,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'KijaScan is an elegant attendance tracking app designed to make checking in and out effortless. Fast, secure, and intuitive for modern organizations.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: dark ? TColors.grey : TColors.darkerGrey,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
