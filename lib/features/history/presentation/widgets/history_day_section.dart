import 'package:flutter/material.dart';
import 'package:kijascan/features/history/models/history_record.dart';
import 'package:kijascan/features/history/presentation/widgets/history_tile.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class HistoryDaySection extends StatelessWidget {
  final HistoryDayGroup group;

  const HistoryDaySection({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 8),
          child: Row(
            children: [
              Text(
                group.title,
                style: TextStyle(
                  color: dark ? TColors.white : TColors.black,
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
          (record) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HistoryTile(record: record),
          ),
        ),
      ],
    );
  }
}
