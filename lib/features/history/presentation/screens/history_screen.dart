import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/history/presentation/screens/empty_history.dart';
import 'package:kijascan/features/history/presentation/screens/history_header.dart';
import 'package:kijascan/features/history/presentation/screens/statsrow.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/features/history/models/attendance_record.dart';
import 'package:kijascan/features/history/presentation/widgets/employee_details_modal.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color _bg = backgroundColor;
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ColoredBox(
      color: dark ? TColors.dark : TColors.light,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: HistoryHeader(),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Obx(
              () => StatsRow(
                todayCount: controller.todayCount.value,
                weekCount: controller.weekCount.value,
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => _FilterChips(
                  selected: controller.selectedFilter.value,
                  onSelected: controller.setFilter,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: TColors.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                if (controller.groups.isEmpty) {
                  return EmptyHistory();
                }

                return RefreshIndicator(
                  color: TColors.primary,
                  onRefresh: controller.loadHistory,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    itemCount: controller.groups.length,
                    itemBuilder: (context, index) {
                      final group = controller.groups[index];
                      return _DaySection(group: group);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}





class _FilterChips extends StatelessWidget {
  final HistoryFilter selected;
  final ValueChanged<HistoryFilter> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'All',
          isSelected: selected == HistoryFilter.all,
          onTap: () => onSelected(HistoryFilter.all),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Today',
          isSelected: selected == HistoryFilter.today,
          onTap: () => onSelected(HistoryFilter.today),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'This week',
          isSelected: selected == HistoryFilter.week,
          onTap: () => onSelected(HistoryFilter.week),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? TColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : TColors.darkGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final HistoryDayGroup group;

  const _DaySection({required this.group});

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
                  color: HistoryScreen._textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                group.subtitle,
                style: const TextStyle(
                  color: HistoryScreen._muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        ...group.records.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _HistoryTile(record: r),
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final AttendanceRecord record;

  const _HistoryTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(record.employeeName);

    return GestureDetector(
      onTap: () => EmployeeDetailsModal.show(record),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.employeeName,
                    style: const TextStyle(
                      color: HistoryScreen._textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${record.employeeId} · ${record.departmentLabel}',
                    style: const TextStyle(
                      color: HistoryScreen._muted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 12,
                        color: TColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'In',
                        style: TextStyle(
                          color: TColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  record.timeLabel,
                  style: const TextStyle(
                    color: HistoryScreen._muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
  }
}
