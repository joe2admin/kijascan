import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_stat_card.dart';

class ClockedInStatsRow extends StatelessWidget {
  final int todayCount;
  final int weekCount;

  const ClockedInStatsRow({
    super.key,
    required this.todayCount,
    required this.weekCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ClockedInStatCard(
              label: 'Today',
              value: '$todayCount',
              icon: Iconsax.calendar,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClockedInStatCard(
              label: 'This week',
              value: '$weekCount',
              icon: Iconsax.timer,
            ),
          ),
        ],
      ),
    );
  }
}
