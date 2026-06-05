import 'package:flutter/material.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/utils/widgets/employee_avatar.dart';

class ClockedInProfileHeader extends StatelessWidget {
  final ClockedInRecord record;

  const ClockedInProfileHeader({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: EmployeeAvatar(
            name: record.employeeName,
            imageUrl: record.profilePictureUrl,
            size: 96,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          record.employeeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark ? TColors.light : TColors.dark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          record.departmentLabel,
          style: TextStyle(
            color: dark ? TColors.softGrey : TColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
