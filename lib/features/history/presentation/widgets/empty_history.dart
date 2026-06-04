import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 56, color: TColors.darkGrey),
            const SizedBox(height: TSizes.defaultSpace),
            Text(
              'No history yet',
              style: TextStyle(
                color: dark ? TColors.light : TColors.dark,
                fontSize: TSizes.fontSizeMd,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completed clock-ins will appear here.',
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
