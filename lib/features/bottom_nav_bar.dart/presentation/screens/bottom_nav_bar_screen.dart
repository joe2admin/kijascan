import 'package:flutter/material.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KijaScan — Bottom Navigation Bar
// A standalone widget. Pass the [controller] for the centre scan action,
// and [selectedIndex] + [onTabChanged] to drive tab selection from the parent.
// ─────────────────────────────────────────────────────────────────────────────

class ScannerBottomNavBar extends StatelessWidget {
  final QrScannerController controller;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ScannerBottomNavBar({
    super.key,
    required this.controller,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  // ── Green palette ──────────────────────────────────────────────────────────
  static const Color _green = Color(0xFF22C55E);       // primary accent
  static const Color _greenGlow = Color(0x3322C55E);   // glow / shadow

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? const Color(0xFF0F1A12)   // dark: very deep green-tinted black
        : Colors.white;

    final borderColor = isDark
        ? _green.withOpacity(0.18)
        : _green.withOpacity(0.25);

    final inactiveColor = isDark
        ? Colors.white.withOpacity(0.35)
        : Colors.black.withOpacity(0.3);

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Tab 0 — History ──────────────────────────────────────────
            Expanded(
              child: _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                isActive: selectedIndex == 0,
                activeColor: _green,
                inactiveColor: inactiveColor,
                onTap: () => onTabChanged(0),
              ),
            ),

            // ── Centre FAB — Scan ────────────────────────────────────────
            Expanded(
              child: Center(
                child: _ScanFab(
                  onTap: () => controller.openCheckIn('user_uuid_987654321'),
                  color: _green,
                  glowColor: _greenGlow,
                ),
              ),
            ),

            // ── Tab 2 — Employees ────────────────────────────────────────
            Expanded(
              child: _NavItem(
                icon: Icons.group_outlined,
                label: 'Employees',
                isActive: selectedIndex == 2,
                activeColor: _green,
                inactiveColor: inactiveColor,
                onTap: () => onTabChanged(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable nav tab item
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: color,
              fontSize: 10,
              letterSpacing: 0.4,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Centre floating scan button
// ─────────────────────────────────────────────────────────────────────────────
class _ScanFab extends StatefulWidget {
  final VoidCallback onTap;
  final Color color;
  final Color glowColor;

  const _ScanFab({
    required this.onTap,
    required this.color,
    required this.glowColor,
  });

  @override
  State<_ScanFab> createState() => _ScanFabState();
}

class _ScanFabState extends State<_ScanFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_) {
    _ctrl.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor,
                blurRadius: 18,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}