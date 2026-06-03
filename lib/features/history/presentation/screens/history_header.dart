import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class HistoryHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
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
          'Recent employee check-ins',
          style: TextStyle(
            color: dark ? TColors.light : TColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}