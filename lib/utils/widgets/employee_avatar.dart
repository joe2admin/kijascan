import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';

/// Reusable employee avatar — shows the profile image if available,
/// falls back to styled initials.
class EmployeeAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  /// Size of the avatar (both width and height).
  final double size;

  /// Border radius — use null for a circle, or provide a value for rounded square.
  final double? borderRadius;

  /// Gradient used for the initials fallback background.
  final Gradient? gradient;

  /// Solid color used for initials fallback background (ignored if gradient set).
  final Color? fallbackColor;

  /// Font size for the initials text.
  final double? fontSize;

  const EmployeeAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
    this.borderRadius,
    this.gradient,
    this.fallbackColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    final isCircle = borderRadius == null;
    final resolvedRadius = borderRadius ?? 0;
    final resolvedFontSize = fontSize ?? size * 0.35;

    final shape = isCircle
        ? const BoxDecoration(shape: BoxShape.circle)
        : BoxDecoration(borderRadius: BorderRadius.circular(resolvedRadius));

    // Initials fallback widget
    Widget fallback = Container(
      width: size,
      height: size,
      decoration: shape.copyWith(
        gradient:
            gradient ??
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
            ),
        color: gradient == null ? fallbackColor : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: resolvedFontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return fallback;

    // Image with clipping
    Widget image = Image.network(
      imageUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: size,
          height: size,
          color: Colors.black12,
          alignment: Alignment.center,
          child: SizedBox(
            width: size * 0.4,
            height: size * 0.4,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
              color: TColors.primary,
            ),
          ),
        );
      },
      errorBuilder: (_, error, __) {
        debugPrint('EmployeeAvatar load error [$imageUrl]: $error');
        return fallback;
      },
    );

    if (isCircle) {
      return ClipOval(child: image);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(resolvedRadius),
      child: image,
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
