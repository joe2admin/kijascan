import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class EmptyClockedIn extends StatelessWidget {
  const EmptyClockedIn({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.login_rounded, size: 56, color: TColors.darkGrey),
            const SizedBox(height: TSizes.defaultSpace),
            Text(
              'No one clocked in yet',
              style: TextStyle(
                color: dark ? TColors.light : TColors.dark,
                fontSize: TSizes.fontSizeMd,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Clocked-in people for this period will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColors.darkGrey,
                fontSize: TSizes.fontSizeSm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
