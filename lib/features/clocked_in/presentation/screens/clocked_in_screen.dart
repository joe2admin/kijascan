import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/empty_clocked_in.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_header.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_stats_row.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_day_section.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_filter_chips.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';

class ClockedInScreen extends GetView<ClockedInController> {
  const ClockedInScreen({super.key});

  static const Color backgroundColor = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ColoredBox(
      color: dark ? TColors.dark : TColors.light,
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: const ClockedInHeader(),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Obx(
                  () => ClockedInStatsRow(
                    todayCount: controller.todayCount.value,
                    totalCount: controller.totalCount.value,
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => ClockedInFilterChips(
                      selected: controller.selectedFilter.value,
                      onSelected: controller.setFilter,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    Widget content;
                    if (controller.isLoading.value) {
                      content = const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          color: TColors.primary,
                          strokeWidth: 2.5,
                        ),
                      );
                    } else if (controller.groups.isEmpty) {
                      content = const EmptyClockedIn(key: ValueKey('empty'));
                    } else {
                      content = RefreshIndicator(
                        key: const ValueKey('list'),
                        color: TColors.primary,
                        onRefresh: controller.loadClockedIn,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                          itemCount: controller.groups.length,
                          itemBuilder: (context, index) {
                            final group = controller.groups[index];
                            return ClockedInDaySection(group: group);
                          },
                        ),
                      );
                    }
                    
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: content,
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            right: 24,
            child: Obx(
              () => FloatingActionButton.extended(
                onPressed: controller.groups.isEmpty
                    ? null
                    : () => _openBulkClockOut(context),
                backgroundColor: TColors.primary,
                icon: const Icon(
                  Iconsax.people,
                  size: 22,
                  color: TColors.white,
                ),
                label: const Text(
                  'Bulk\nClock Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TSizes.fontSizeSm,
                    fontWeight: FontWeight.w600,
                    color: TColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBulkClockOut(BuildContext context) {
    // Pass all groups to bulk clock out screen
    Get.toNamed(AppRoutes.bulkClockOut, arguments: controller.groups.toList());
  }
}
