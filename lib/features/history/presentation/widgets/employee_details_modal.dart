import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/check_in/presentation/widgets/employee_ticket_card.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/features/history/models/attendance_record.dart';

class EmployeeDetailsModal extends GetView<HistoryController> {
  final AttendanceRecord record;

  const EmployeeDetailsModal({super.key, required this.record});

  static const Color _red = Color(0xFFEF4444);
  static const Color _bg = Color(0xFFF3F4F6);
  static const Color _textDark = Color(0xFF1F2937);
  static const Color _muted = Color(0xFF9CA3AF);

  static Future<void> show(AttendanceRecord record) {
    return Get.bottomSheet(
      EmployeeDetailsModal(record: record),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  _ModalProfileHeader(record: record),
                  const SizedBox(height: 24),
                  EmployeeTicketCard(
                    cardColor: Colors.white,
                    backgroundColor: _bg,
                    labelColor: _muted,
                    valueColor: _textDark,
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
            () => _CheckOutBar(
              isSubmitting: controller.isCheckingOut.value,
              onCheckOut: () => controller.submitCheckOut(record),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalProfileHeader extends StatelessWidget {
  final AttendanceRecord record;

  const _ModalProfileHeader({required this.record});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(record.employeeName);

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          record.employeeName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: EmployeeDetailsModal._textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          record.departmentLabel,
          style: const TextStyle(
            color: EmployeeDetailsModal._muted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
  }
}

class _CheckOutBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCheckOut;

  const _CheckOutBar({
    required this.isSubmitting,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: isSubmitting ? null : onCheckOut,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            opacity: isSubmitting ? 0.7 : 1,
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: EmployeeDetailsModal._red,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: EmployeeDetailsModal._red.withValues(alpha: 0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Check Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
