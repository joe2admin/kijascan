import 'package:flutter/material.dart';

class TColors {
  TColors._();

  // ── Brand ────────────────────────────────────────────
  static const Color primary = Color(0xFF1B7E44);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFF1B7E44);

  // ── Gradient ─────────────────────────────────────────
  static const LinearGradient linearGradient = LinearGradient(
    colors: [primary, Color.fromARGB(255, 147, 238, 180)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text ─────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color white = Colors.white;

  // ── Backgrounds ──────────────────────────────────────
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF111D15); // Very dark forest green
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // ── Containers ───────────────────────────────────────
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Color(0xFF19291D); // Deep forest green for cards/containers

  // ── Buttons ──────────────────────────────────────────
  // Tip: buttonPrimary == primary — you can just use primary directly
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // ── Borders ──────────────────────────────────────────
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // ── Semantic (Information) ────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // ── Grey scale (lightest → darkest) ──────────────────
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF939393);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color black = Color(0xFF232323);

  //CARD COLORS
  static const Color darkCardbg = Color(0xFF19291D);
  static const Color lightCardbg = Color(0xFFD2F7D7);
}
