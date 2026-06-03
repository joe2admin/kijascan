import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart%20';

/// Dims the camera feed everywhere except the scan window, with corner brackets only.
class ScannerViewportOverlay extends StatelessWidget {
  
  final Rect scanWindow;
  final Color cornerColor;
  final double cornerStrokeWidth;
  final double cornerLength;

  const ScannerViewportOverlay({
    super.key,
    required this.scanWindow,
    this.cornerColor = TColors.accent,
    this.cornerStrokeWidth = 3.5,
    this.cornerLength = 32,
  });

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: _OverlayPainter(
        scanWindow: scanWindow,
        overlayColor: const Color(0x99000000),
        cornerColor: cornerColor,
        cornerStrokeWidth: cornerStrokeWidth,
        cornerLength: cornerLength,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final Color overlayColor;
  final Color cornerColor;
  final double cornerStrokeWidth;
  final double cornerLength;

  _OverlayPainter({
    required this.scanWindow,
    required this.overlayColor,
    required this.cornerColor,
    required this.cornerStrokeWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const cornerRadius = 20.0;

    final full = Path()..addRect(Offset.zero & size);
    final cutout = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(cornerRadius)),
      );
    final dim = Path.combine(PathOperation.difference, full, cutout);

    canvas.drawPath(dim, Paint()..color = overlayColor);

    canvas.drawPath(
      _cornerBracketsPath(scanWindow, cornerLength, cornerRadius),
      Paint()
        ..color = cornerColor
        ..strokeWidth = cornerStrokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  Path _cornerBracketsPath(Rect rect, double length, double radius) {
    final path = Path();
    final left = rect.left;
    final top = rect.top;
    final right = rect.right;
    final bottom = rect.bottom;

    // Top-left
    path.moveTo(left, top + length);
    path.lineTo(left, top + radius);
    path.quadraticBezierTo(left, top, left + radius, top);
    path.lineTo(left + length, top);

    // Top-right
    path.moveTo(right - length, top);
    path.lineTo(right - radius, top);
    path.quadraticBezierTo(right, top, right, top + radius);
    path.lineTo(right, top + length);

    // Bottom-left
    path.moveTo(left, bottom - length);
    path.lineTo(left, bottom - radius);
    path.quadraticBezierTo(left, bottom, left + radius, bottom);
    path.lineTo(left + length, bottom);

    // Bottom-right
    path.moveTo(right - length, bottom);
    path.lineTo(right - radius, bottom);
    path.quadraticBezierTo(right, bottom, right, bottom - radius);
    path.lineTo(right, bottom - length);

    return path;
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) =>
      old.scanWindow != scanWindow || old.cornerColor != cornerColor;
}
