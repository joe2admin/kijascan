import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/check_in/presentation/widgets/employee_ticket_card.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_check_out_bar.dart';
import 'package:kijascan/features/clocked_in/presentation/widgets/clocked_in_profile_header.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class ClockedInDetailsModal extends GetView<ClockedInController> {
  final ClockedInRecord record;

  const ClockedInDetailsModal({super.key, required this.record});

  static Future<void> show(ClockedInRecord record) {
    return Get.bottomSheet(
      ClockedInDetailsModal(record: record),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.light,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 16 + bottomInset),
              child: Column(
                children: [
                  ClockedInProfileHeader(record: record),
                  const SizedBox(height: 24),
                  EmployeeTicketCard(
                    cardColor: dark? TColors.dark : TColors.white,
                    backgroundColor: dark ? TColors.dark : TColors.softGrey,
                    labelColor: dark ? TColors.softGrey : TColors.darkGrey,
                    valueColor: dark ? TColors.light : TColors.dark,
                    headerDate: record.dateLabel,
                    employeeId: record.employeeId,
                    department: record.departmentLabel,
                    positionRole: record.role,
                    checkedInTime: record.timeLabel,
                    date: record.dateLabel,
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => ClockedInCheckOutBar(
              isSubmitting: controller.isCheckingOut.value,
              onCheckOut: () => controller.submitCheckOut(record),
            ),
          ),
        ],
      ),
    );
  }
}
