import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/features/history/presentation/screens/stats_card.dart';

class StatsRow extends StatelessWidget {
  final int todayCount;
  final int weekCount;

  const StatsRow({required this.todayCount, required this.weekCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              label: 'Today',
              value: '$todayCount',
              icon: Iconsax.calendar,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
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
