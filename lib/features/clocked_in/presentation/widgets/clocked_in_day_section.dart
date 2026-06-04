import 'package:flutter/material.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_tile.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class ClockedInDaySection extends StatelessWidget {
  final ClockedInDayGroup group;

  const ClockedInDaySection({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 8),
          child: Row(
            children: [
              Text(
                group.title,
                style: const TextStyle(
                  color: TColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                group.subtitle,
                style: const TextStyle(
                  color: TColors.darkGrey,
                  fontSize: TSizes.fontSizeSm,
                ),
              ),
            ],
          ),
        ),
        ...group.records.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClockedInTile(record: r),
          ),
        ),
      ],
    );
  }
}
