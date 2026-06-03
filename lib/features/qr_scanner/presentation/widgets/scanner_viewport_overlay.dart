import 'package:flutter/material.dart';

/// Dims the camera feed everywhere except a centered rounded scan window.
class ScannerViewportOverlay extends StatelessWidget {
  final double scanSize;
  final double borderRadius;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;

  const ScannerViewportOverlay({
    super.key,
    this.scanSize = 260,
    this.borderRadius = 24,
    this.overlayColor = const Color(0x99000000),
    this.borderColor = const Color(0xFF22C55E),
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hole = Rect.fromCenter(
          center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2 - 24),
          width: scanSize,
          height: scanSize,
        );

        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _OverlayPainter(
                hole: hole,
                borderRadius: borderRadius,
                overlayColor: overlayColor,
                borderColor: borderColor,
                borderWidth: borderWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect hole;
  final double borderRadius;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;

  _OverlayPainter({
    required this.hole,
    required this.borderRadius,
    required this.overlayColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final cutout = Path()
      ..addRRect(
        RRect.fromRectAndRadius(hole, Radius.circular(borderRadius)),
      );
    final dim = Path.combine(PathOperation.difference, full, cutout);

    canvas.drawPath(dim, Paint()..color = overlayColor);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(
      RRect.fromRectAndRadius(hole, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) =>
      old.hole != hole || old.overlayColor != overlayColor;
}
