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
        backgroundColor: dark ? TColors.dark : TColors.light,
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
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: TColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.selectedCount}/${controller.employees.length}',
                  style: const TextStyle(
                    color: TColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: _SelectAllHeader(dark: dark),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // padding bottom for fab
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (controller.employees.isEmpty) return const SizedBox.shrink();
        
        final isButtonDisabled = controller.isProcessing.value || !controller.hasSelection;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 16),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: isButtonDisabled ? [] : [
              BoxShadow(
                color: TColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
                letterSpacing: -0.2,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SelectAllHeader extends StatelessWidget {
  final bool dark;

  const _SelectAllHeader({required this.dark});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BulkClockOutController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select employees',
          style: TextStyle(
            color: dark ? Colors.white54 : Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(
          () => GestureDetector(
            onTap: () {
              controller.toggleSelectAll(!controller.selectAll.value);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.selectAll.value ? 'Deselect All' : 'Select All',
                  style: const TextStyle(
                    color: TColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectAll.value ? TColors.primary : (dark ? Colors.white24 : Colors.black26),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: controller.selectAll.value ? TColors.primary : Colors.transparent,
                    ),
                    child: controller.selectAll.value
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? TColors.primary.withValues(alpha: 0.1)
            : (dark ? TColors.darkContainer : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? TColors.primary.withValues(alpha: 0.5)
              : (dark ? Colors.transparent : TColors.grey.withValues(alpha: 0.5)),
          width: 1.5,
        ),
        boxShadow: dark || isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        employee.employeeName,
                        style: TextStyle(
                          color: dark ? Colors.white : TColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        employee.role,
                        style: TextStyle(
                          color: dark ? Colors.white54 : Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.clock,
                        size: 12,
                        color: TColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        employee.timeLabel,
                        style: const TextStyle(
                          color: TColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? TColors.primary : (dark ? Colors.white24 : Colors.black26),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: isSelected ? TColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
