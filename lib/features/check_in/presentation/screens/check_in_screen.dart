import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/check_in_controller.dart';
import '../../models/scanned_employee.dart';

class CheckInScreen extends GetView<CheckInController> {
  const CheckInScreen({super.key});

  static const Color _green = Color(0xFF22C55E);
  static const Color _greenDeep = Color(0xFF16A34A);
  static const Color _darkBg = Color(0xFF0A120D);
  static const Color _darkCard = Color(0xFF0F1A12);
  static const Color _darkSurface = Color(0xFF141F17);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? _darkBg : const Color(0xFFF8FAF9);
    final card = isDark ? _darkCard : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F1A12);
    final textMuted = isDark ? Colors.white60 : Colors.black54;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: textPrimary, size: 20),
            onPressed: controller.cancel,
          ),
          title: Text(
            'Confirm attendance',
            style: TextStyle(
              color: textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
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
                    color: _green,
                    strokeWidth: 2.5,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Looking up employee…',
                    style: TextStyle(color: textMuted, fontSize: 14),
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
                style: TextStyle(color: textMuted),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EmployeeCard(
                  employee: employee,
                  cardColor: card,
                  surfaceColor: isDark ? _darkSurface : const Color(0xFFF1F5F2),
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  accentColor: _green,
                ),
                const SizedBox(height: 20),
                _StatusBanner(
                  employee: employee,
                  isDark: isDark,
                  accentColor: _green,
                ),
                const SizedBox(height: 28),
                Text(
                  'Record attendance',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose whether this person is arriving or leaving.',
                  style: TextStyle(color: textMuted, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final submitting = controller.isSubmitting.value;
                  final lastAction = controller.lastAction.value;

                  return Column(
                    children: [
                      _ActionButton(
                        label: 'Check In',
                        icon: Icons.login_rounded,
                        filled: true,
                        color: _green,
                        textColor: Colors.white,
                        isLoading: submitting &&
                            lastAction == CheckInAction.checkIn,
                        onTap: submitting
                            ? null
                            : () => controller.submitCheckIn(
                                  CheckInAction.checkIn,
                                ),
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        label: 'Check Out',
                        icon: Icons.logout_rounded,
                        filled: false,
                        color: _greenDeep,
                        textColor: _greenDeep,
                        isLoading: submitting &&
                            lastAction == CheckInAction.checkOut,
                        onTap: submitting
                            ? null
                            : () => controller.submitCheckIn(
                                  CheckInAction.checkOut,
                                ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final ScannedEmployee employee;
  final Color cardColor;
  final Color surfaceColor;
  final Color textPrimary;
  final Color textMuted;
  final Color accentColor;

  const _EmployeeCard({
    required this.employee,
    required this.cardColor,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textMuted,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(employee.fullName);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.role,
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${employee.department} · ${employee.id}',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.elementAt(1)[0]}'.toUpperCase();
  }
}

class _StatusBanner extends StatelessWidget {
  final ScannedEmployee employee;
  final bool isDark;
  final Color accentColor;

  const _StatusBanner({
    required this.employee,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final checkedIn = employee.isCurrentlyCheckedIn;
    final bg = checkedIn
        ? accentColor.withOpacity(isDark ? 0.12 : 0.08)
        : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04));
    final icon = checkedIn ? Icons.schedule_rounded : Icons.info_outline_rounded;
    final title = checkedIn ? 'Currently checked in' : 'Not checked in';
    final subtitle = employee.lastCheckInAt != null
        ? 'Last activity: ${employee.lastCheckInAt}'
        : 'No recent attendance on file';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: checkedIn
              ? accentColor.withOpacity(0.25)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F1A12),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.color,
    required this.textColor,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: onTap == null && !isLoading ? 0.5 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: filled ? null : Border.all(color: color, width: 1.5),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: filled ? Colors.white : color,
                  ),
                )
              else ...[
                Icon(icon, color: filled ? Colors.white : textColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: filled ? Colors.white : textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
