import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';
import '../../controllers/check_in_controller.dart';
import '../../models/scanned_employee.dart';
import '../widgets/employee_ticket_card.dart';

class CheckInScreen extends GetView<CheckInController> {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: dark ? TColors.dark : TColors.light,
        appBar: AppBar(
          backgroundColor: dark ? TColors.dark : TColors.softGrey,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: dark ? TColors.softGrey: TColors.black,
              size: 20,
            ),
            onPressed: controller.cancel,
          ),
          title: Text(
            'Employee details',
            style: TextStyle(
              color: dark ? TColors.white : TColors.black,
              fontSize: TSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoadingEmployee.value) {
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
                    'Looking up employee…',
                    style: TextStyle(
                      color: TColors.darkGrey,
                      fontSize: TSizes.fontSizeSm,
                    ),
                  ),
                ],
              ),
            );
          }

          final employee = controller.employee.value;
          if (employee == null) {
            return Center(
              child: Text(
                'Could not load employee details.',
                style: TextStyle(color: TColors.darkGrey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    children: [
                      _ProfileHeader(
                        employee: employee,
                        textPrimary: dark ? TColors.softGrey : TColors.black,
                        isDark: dark,
                      ),
                      const SizedBox(height: 28),
                      EmployeeTicketCard(
                        cardColor: dark
                            ? const Color.fromARGB(255, 25, 30, 27)
                            : TColors.white,
                        backgroundColor: dark
                            ? TColors.dark
                            : TColors.softGrey,
                        labelColor: dark ? TColors.white : TColors.dark,
                        valueColor: dark ? TColors.white : TColors.dark,
                        headerDate: employee.attendanceDate,
                        employeeId: employee.id,
                        department: employee.department,
                        positionRole: employee.role,
                        checkedInTime: employee.checkedInTimeDisplay,
                        date: employee.attendanceDate,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => _CheckInBar(
                  isSubmitting: controller.isSubmitting.value,
                  onCheckIn: controller.submitCheckIn,
                  isDark: dark,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Centered avatar + full name (profile inspiration).
class _ProfileHeader extends StatelessWidget {
  final ScannedEmployee employee;
  final Color textPrimary;
  final bool isDark;

  const _ProfileHeader({
    required this.employee,
    required this.textPrimary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EmployeeAvatar(
          name: employee.fullName,
          imageUrl: employee.imageUrl,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Text(
          employee.fullName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          employee.department,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textPrimary.withValues(alpha: 0.55),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmployeeAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isDark;

  const _EmployeeAvatar({
    required this.name,
    required this.imageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const size = 112.0;
    final initials = _initials(name);

    Widget child;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _initialsAvatar(initials, size),
        ),
      );
    } else {
      child = _initialsAvatar(initials, size);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _initialsAvatar(String initials, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.elementAt(1)[0]}'.toUpperCase();
  }
}

class _CheckInBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCheckIn;
  final bool isDark;

  const _CheckInBar({
    required this.isSubmitting,
    required this.onCheckIn,
    required this.isDark,
  });

  static const Color _green = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final barBg = isDark ? TColors.dark : TColors.softGrey;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: barBg,
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: isSubmitting ? null : onCheckIn,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            opacity: isSubmitting ? 0.7 : 1,
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.32),
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
                        color: TColors.softGrey,
                      ),
                    )
                  : const Text(
                      'Check In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
