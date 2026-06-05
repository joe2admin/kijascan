import 'package:flutter/material.dart';
import 'package:kijascan/features/history/models/history_record.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/utils/widgets/employee_avatar.dart';

class HistoryTile extends StatelessWidget {
  final HistoryRecord record;

  const HistoryTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.white,
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
        children: [
          EmployeeAvatar(
            name: record.employeeName,
            imageUrl: record.profilePictureUrl,
            size: 48,
            borderRadius: 14,
            fallbackColor: TColors.primary.withValues(alpha: 0.12),
            gradient: null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.employeeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? TColors.white : TColors.black,
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.employeeId} - ${record.departmentLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TColors.darkGrey,
                    fontSize: TSizes.fontSizeSm,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'In ${record.checkedInTimeLabel} - Out ${record.checkedOutTimeLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? TColors.softGrey : TColors.darkerGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout_rounded, size: 12, color: TColors.error),
                    SizedBox(width: 4),
                    Text(
                      'Out',
                      style: TextStyle(
                        color: TColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                record.durationLabel,
                style: TextStyle(
                  color: dark ? TColors.darkGrey : TColors.darkerGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
