import 'package:flutter/material.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_details_modal.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/utils/widgets/employee_avatar.dart';

class ClockedInTile extends StatelessWidget {
  final ClockedInRecord record;

  const ClockedInTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => ClockedInDetailsModal.show(record),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dark ? TColors.darkContainer : TColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EmployeeAvatar(
              name: record.employeeName,
              imageUrl: record.profilePictureUrl,
              size: 48,
              borderRadius: 14,
              gradient: const LinearGradient(
                colors: [TColors.primary, TColors.accent],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          record.employeeName,
                          style: TextStyle(
                            color: dark ? TColors.white : TColors.black,
                            fontSize: TSizes.fontSizeMd,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: TColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'In',
                          style: TextStyle(
                            color: TColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.employeeId} - ${record.departmentLabel}',
                    style: const TextStyle(
                      color: TColors.darkGrey,
                      fontSize: TSizes.fontSizeSm,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              record.timeLabel,
              style: TextStyle(
                color: dark ? TColors.darkGrey : TColors.darkerGrey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
