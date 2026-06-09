import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/features/history/presentation/widgets/history_stat_card.dart';

class HistoryStatsRow extends StatelessWidget {
  final int todayCount;
  final int weekCount;
  final int totalCount;

  const HistoryStatsRow({
    super.key,
    required this.todayCount,
    required this.weekCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: HistoryStatCard(
              label: 'Today',
              value: '$todayCount',
              icon: Iconsax.calendar_1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: HistoryStatCard(
              label: 'This week',
              value: '$weekCount',
              icon: Iconsax.timer_1,
            ),
          ),
        ],
      ),
    );
  }
}
