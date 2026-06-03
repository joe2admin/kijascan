import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/bottom_nav_bar.dart/presentation/screens/bottom_nav_bar_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/qr_scanner_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KijaScan — QR Scanner Screen
//
// Color system:
//   Light mode : green accent on white surfaces
//   Dark mode  : green accent on deep dark surfaces
//
// Removed from previous version:
//   • Scanning progress badge
//   • Check-in / Check-out badge
//
// New:
//   • Theme-aware scaffold & overlays
//   • ScannerBottomNavBar extracted as its own widget (see scanner_bottom_nav_bar.dart)
// ─────────────────────────────────────────────────────────────────────────────

class QrScannerScreen extends GetView<QrScannerController> {
  const QrScannerScreen({super.key});

  // ── Green palette constants ────────────────────────────────────────────────
  static const Color _green = Color(0xFF22C55E);
  static const Color _greenLight = Color(0xFF4ADE80);
  static const Color _greenDeep = Color(0xFF16A34A);

  // ── Dark mode surfaces ─────────────────────────────────────────────────────
  static const Color _darkBg = Color(0xFF0A120D);
  static const Color _darkCard = Color(0xFF0F1A12);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Status bar icons: white on dark camera feed
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: isDark ? _darkBg : Colors.white,
      body: Stack(
        children: [
          // ── Full-bleed camera feed (above bottom bar) ──────────────────
          Positioned.fill(
            bottom: 72,
            child: MobileScanner(
              controller: controller.cameraController,
              onDetect: controller.onDetect,
            ),
          ),

          // ── Gradient overlay: top ──────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            height: 140,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (isDark ? _darkBg : Colors.black).withOpacity(0.72),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Gradient overlay: bottom (above nav bar) ───────────────────
          Positioned(
            bottom: 72, left: 0, right: 0,
            height: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    (isDark ? _darkBg : Colors.black).withOpacity(0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Top bar: back arrow + app name + torch ─────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back / close
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Get.back(),
                  ),
                  const Spacer(),
                  // App name
                  const Text(
                    'KijaScan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  // Torch toggle
                  _CircleButton(
                    icon: Icons.bolt_rounded,
                    onTap: controller.cameraController.toggleTorch,
                  ),
                ],
              ),
            ),
          ),

          // ── Scan frame centred on screen ───────────────────────────────
          Center(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: _ScanFrame(
                size: 220,
                bracketColor: _green,
                sweepColorStart: _green,
                sweepColorMid: _greenLight,
              ),
            ),
          ),

          // ── Reactive overlay (loading / success) ───────────────────────
          Obx(() {
            if (controller.isLoading.value) {
              return _LoadingOverlay(
                message: controller.statusMessage.value,
                accentColor: _green,
                isDark: isDark,
              );
            }
            if (controller.scanResult.value.isNotEmpty) {
              return _SuccessOverlay(
                message: controller.statusMessage.value,
                accentColor: _green,
                deepColor: _greenDeep,
                cardColor: isDark ? _darkCard : Colors.white,
                isDark: isDark,
                onReset: controller.resetScanner,
              );
            }
            return const SizedBox.shrink();
          }),

          // ── Bottom navigation bar (separate widget) ────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ScannerBottomNavBar(
              controller: controller,
              selectedIndex: 1, // scanner tab is centre (index 1)
              onTabChanged: (index) {
                // Handle navigation: e.g. Get.toNamed('/history') for index 0
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small circular icon button (top bar)
// ─────────────────────────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scan frame: corner brackets + animated green sweep
// ─────────────────────────────────────────────────────────────────────────────
class _ScanFrame extends StatefulWidget {
  final double size;
  final Color bracketColor;
  final Color sweepColorStart;
  final Color sweepColorMid;

  const _ScanFrame({
    required this.size,
    required this.bracketColor,
    required this.sweepColorStart,
    required this.sweepColorMid,
  });

  @override
  State<_ScanFrame> createState() => _ScanFrameState();
}

class _ScanFrameState extends State<_ScanFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _sweep;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _sweep = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        children: [
          // Corner brackets
          CustomPaint(
            size: Size(s, s),
            painter: _CornerBracketPainter(
              color: widget.bracketColor,
              strokeWidth: 3.5,
              bracketLength: 26,
              cornerRadius: 4,
            ),
          ),

          // Animated sweep line
          AnimatedBuilder(
            animation: _sweep,
            builder: (_, __) {
              final y = _sweep.value * (s - 4);
              final opacity =
                  sin(_sweep.value * pi).clamp(0.0, 1.0).toDouble();
              return Positioned(
                left: 6,
                right: 6,
                top: y,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          widget.sweepColorStart,
                          widget.sweepColorMid,
                          widget.sweepColorStart,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                      boxShadow: [
                        BoxShadow(
                          color: widget.sweepColorStart.withOpacity(0.55),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Corner bracket CustomPainter
// ─────────────────────────────────────────────────────────────────────────────
class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double bracketLength;
  final double cornerRadius;

  const _CornerBracketPainter({
    required this.color,
    required this.strokeWidth,
    required this.bracketLength,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final r = cornerRadius;
    final l = bracketLength;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, l)
        ..lineTo(0, r)
        ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
        ..lineTo(l, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - l, 0)
        ..lineTo(w - r, 0)
        ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
        ..lineTo(w, l),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, h - l)
        ..lineTo(0, h - r)
        ..arcToPoint(Offset(r, h), radius: Radius.circular(r))
        ..lineTo(l, h),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w - l, h)
        ..lineTo(w - r, h)
        ..arcToPoint(Offset(w, h - r), radius: Radius.circular(r))
        ..lineTo(w, h - l),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.bracketLength != bracketLength;
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading overlay
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingOverlay extends StatelessWidget {
  final String message;
  final Color accentColor;
  final bool isDark;

  const _LoadingOverlay({
    required this.message,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.55),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: accentColor,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 18),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success overlay
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessOverlay extends StatelessWidget {
  final String message;
  final Color accentColor;
  final Color deepColor;
  final Color cardColor;
  final bool isDark;
  final VoidCallback onReset;

  const _SuccessOverlay({
    required this.message,
    required this.accentColor,
    required this.deepColor,
    required this.cardColor,
    required this.isDark,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? accentColor.withOpacity(0.35) : accentColor.withOpacity(0.25);
    final textColor = isDark ? Colors.white : const Color(0xFF0F1A12);
    final subTextColor =
        isDark ? Colors.white60 : Colors.black.withOpacity(0.45);

    return Container(
      color: Colors.black.withOpacity(0.7),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Success icon ─────────────────────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: accentColor,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            // ── Status message ───────────────────────────────────────────
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Employee recorded successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 24),

            // ── Scan Another button ──────────────────────────────────────
            GestureDetector(
              onTap: onReset,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Scan Another',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Dismiss / go back ────────────────────────────────────────
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                'Done',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}