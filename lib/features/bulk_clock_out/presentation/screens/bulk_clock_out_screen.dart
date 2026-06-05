import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import '../../controllers/bulk_clock_out_controller.dart';

class BulkClockOutScreen extends GetView<BulkClockOutController> {
  const BulkClockOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      appBar: AppBar(
        backgroundColor: dark ? TColors.dark : TColors.softGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark ? TColors.softGrey : TColors.black,
            size: 20,
          ),
          onPressed: controller.cancel,
        ),
        title: Text(
          'Bulk Clock Out',
          style: TextStyle(
            color: dark ? TColors.white : TColors.black,
            fontSize: TSizes.fontSizeXl,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(
              () => Center(
                child: Text(
                  '${controller.selectedCount}/${controller.employees.length}',
                  style: TextStyle(
                    color: TColors.primary,
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: TColors.primary,
                  strokeWidth: 2.5,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading employees…',
                  style: TextStyle(
                    color: dark ? TColors.accent : TColors.dark,
                    fontSize: TSizes.fontSizeSm,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.employees.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 56,
                  color: dark ? Colors.white30 : Colors.black12,
                ),
                const SizedBox(height: 16),
                Text(
                  'No employees clocked in',
                  style: TextStyle(
                    color: dark ? TColors.accent : TColors.dark,
                    fontSize: TSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Everyone has been checked out.',
                  style: TextStyle(
                    color: dark ? TColors.accent : TColors.dark,
                    fontSize: TSizes.fontSizeSm,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _SelectAllCheckbox(dark: dark),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: controller.employees.length,
                itemBuilder: (context, index) {
                  final employee = controller.employees[index];
                  return Obx(() {
                    final isSelected = controller.isSelected(employee.id);
                    return _EmployeeListTile(
                      employee: employee,
                      isSelected: isSelected,
                      onTap: () => controller.toggleSelection(employee.id),
                      dark: dark,
                    );
                  });
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Obx(
            () {
              final isButtonDisabled = controller.isProcessing.value || !controller.hasSelection;
              return SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: dark
                        ? const Color(0xFF2C3530)
                        : const Color(0xFFE5E7EB),
                    disabledForegroundColor: dark
                        ? Colors.white24
                        : Colors.black26,
                    elevation: 0,
                    shadowColor: TColors.primary.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: isButtonDisabled
                      ? null
                      : controller.submitBulkClockOut,
                  icon: controller.isProcessing.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Iconsax.logout,
                          size: 20,
                          color: isButtonDisabled
                              ? (dark ? Colors.white24 : Colors.black26)
                              : Colors.white,
                        ),
                  label: Text(
                    controller.isProcessing.value
                        ? 'Clocking out…'
                        : 'Clock Out ${controller.selectedCount > 0 ? '(${controller.selectedCount})' : ''}',
                    style: const TextStyle(
                      fontSize: TSizes.fontSizeMd,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelectAllCheckbox extends StatelessWidget {
  final bool dark;

  const _SelectAllCheckbox({required this.dark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BulkClockOutController>();

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: dark
              ? const Color.fromARGB(255, 25, 30, 27)
              : TColors.softGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: controller.selectAll.value,
              onChanged: (value) {
                controller.toggleSelectAll(value ?? false);
              },
              activeColor: TColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              controller.selectAll.value ? 'Deselect All' : 'Select All',
              style: TextStyle(
                color: dark ? Colors.white : TColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeListTile extends StatelessWidget {
  final ClockedInRecord employee;
  final bool isSelected;
  final VoidCallback onTap;
  final bool dark;

  const _EmployeeListTile({
    required this.employee,
    required this.isSelected,
    required this.onTap,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? TColors.primary.withValues(alpha: 0.08)
            : dark
            ? TColors.black
            : TColors.grey,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: TColors.primary, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: TColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.employeeName,
                        style: TextStyle(
                          color: dark ? Colors.white : TColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              employee.role,
                              style: TextStyle(
                                color: dark ? Colors.white54 : Colors.black54,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              employee.timeLabel,
                              style: const TextStyle(
                                color: TColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
