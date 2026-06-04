import 'package:flutter/material.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_chips.dart';

class ClockedInFilterChips extends StatelessWidget {
  final ClockedInFilter selected;
  final ValueChanged<ClockedInFilter> onSelected;

  const ClockedInFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClockedInChip(
          label: 'All',
          isSelected: selected == ClockedInFilter.all,
          onTap: () => onSelected(ClockedInFilter.all),
        ),
        const SizedBox(width: 8),
        ClockedInChip(
          label: 'Today',
          isSelected: selected == ClockedInFilter.today,
          onTap: () => onSelected(ClockedInFilter.today),
        ),
        const SizedBox(width: 8),
        ClockedInChip(
          label: 'This week',
          isSelected: selected == ClockedInFilter.week,
          onTap: () => onSelected(ClockedInFilter.week),
        ),
      ],
    );
  }
}
