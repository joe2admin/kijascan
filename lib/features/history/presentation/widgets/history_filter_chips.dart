import 'package:flutter/material.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class HistoryFilterChips extends StatelessWidget {
  final HistoryFilter selected;
  final ValueChanged<HistoryFilter> onSelected;

  const HistoryFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HistoryChip(
          label: 'All',
          isSelected: selected == HistoryFilter.all,
          onTap: () => onSelected(HistoryFilter.all),
        ),
        const SizedBox(width: 8),
        _HistoryChip(
          label: 'Today',
          isSelected: selected == HistoryFilter.today,
          onTap: () => onSelected(HistoryFilter.today),
        ),
        const SizedBox(width: 8),
        _HistoryChip(
          label: 'This week',
          isSelected: selected == HistoryFilter.week,
          onTap: () => onSelected(HistoryFilter.week),
        ),
      ],
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? TColors.primary
              : dark
              ? TColors.dark
              : TColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark
                ? isSelected
                    ? TColors.accent
                    : TColors.darkerGrey
                : isSelected
                    ? TColors.primary
                    : TColors.softGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? TColors.white : TColors.darkGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
