import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/features/history/presentation/widgets/empty_history.dart';
import 'package:kijascan/features/history/presentation/widgets/history_day_section.dart';
import 'package:kijascan/features/history/presentation/widgets/history_filter_chips.dart';
import 'package:kijascan/features/history/presentation/widgets/history_header.dart';
import 'package:kijascan/features/history/presentation/widgets/history_stats_row.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

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
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: HistoryHeader(),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Obx(
              () => HistoryStatsRow(
                todayCount: controller.todayCount.value,
                weekCount: controller.weekCount.value,
                totalCount: controller.totalCount.value,
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => HistoryFilterChips(
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

                if (controller.groups.isEmpty) return const EmptyHistory();

                return RefreshIndicator(
                  color: TColors.primary,
                  onRefresh: controller.loadHistory,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    itemCount: controller.groups.length,
                    itemBuilder: (context, index) {
                      final group = controller.groups[index];
                      return HistoryDaySection(group: group);
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
