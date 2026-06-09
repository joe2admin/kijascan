import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

/// Ticket-style card: date header, dashed divider with side notches, detail grid.
class EmployeeTicketCard extends StatelessWidget {
  final Color cardColor;
  final Color backgroundColor;
  final Color labelColor;
  final Color valueColor;
  final String headerDate;
  final String employeeId;
  final String department;
  final String positionRole;
  final String checkedInTime;
  final String date;

  const EmployeeTicketCard({
    super.key,
    required this.cardColor,
    required this.backgroundColor,
    required this.labelColor,
    required this.valueColor,
    required this.headerDate,
    required this.employeeId,
    required this.department,
    required this.positionRole,
    required this.checkedInTime,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                child: Text(
                  headerDate,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _TicketDividerRow(backgroundColor: backgroundColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: _DetailsGrid(
                  labelColor: labelColor,
                  valueColor: valueColor,
                  employeeId: employeeId,
                  department: THelperFunctions.formatTextToTitleCase(department),
                  positionRole: THelperFunctions.formatTextToTitleCase(positionRole),
                  checkedInTime: checkedInTime,
                  date: date,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketDividerRow extends StatelessWidget {
  final Color backgroundColor;

  const _TicketDividerRow({required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: _DashedLine(),
          ),
          Positioned(left: -10, child: _SideNotch(color: backgroundColor)),
          Positioned(right: -10, child: _SideNotch(color: backgroundColor)),
        ],
      ),
    );
  }
}

class _SideNotch extends StatelessWidget {
  final Color color;

  const _SideNotch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(color: const Color(0xFFD1D5DB)),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  final Color labelColor;
  final Color valueColor;
  final String employeeId;
  final String department;
  final String positionRole;
  final String checkedInTime;
  final String date;

  const _DetailsGrid({
    required this.labelColor,
    required this.valueColor,
    required this.employeeId,
    required this.department,
    required this.positionRole,
    required this.checkedInTime,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DetailCell(
                label: 'Employee ID',
                value: employeeId,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DetailCell(
                label: 'Department',
                value: department,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.defaultSpace),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DetailCell(
                label: 'Position / Role',
                value: positionRole,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DetailCell(
                label: 'Clocked-In Time',
                value: checkedInTime,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 22),
        // _DetailCell(
        //   label: 'Date',
        //   value: date,
        //   labelColor: labelColor,
        //   valueColor: valueColor,
        // ),
      ],
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const _DetailCell({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
