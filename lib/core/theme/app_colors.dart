import 'package:flutter/material.dart';

/// Brand palette for the XZSPACE portfolio.
///
/// The signature look is **dark**: a near-black canvas that makes work pop and
/// reads as premium (Apple / Linear). The accent is Ahmed's brand violet
/// `#6B2D84`, used mostly inside gradient meshes (Stripe-style depth) rather
/// than flat fills. Light mode is a first-class inverse.
///
/// Text never uses pure white on black — a warm-gray ramp reduces eye strain
/// and reads as refined.
class AppColors {
  AppColors._();

  // --- Brand accent ramp (violet) ---------------------------------------
  static const Color violet = Color(0xFF6B2D84); // brand core
  static const Color violetBright = Color(0xFF9D4EDD); // interactive / glow
  static const Color violetSoft = Color(0xFFC77DFF); // highlights
  static const Color magenta = Color(0xFFB5179E); // gradient partner
  static const Color indigo = Color(0xFF3A0CA3); // gradient partner / depth

  // --- Dark theme (signature) -------------------------------------------
  static const Color darkBg = Color(0xFF0A0A0B); // page canvas
  static const Color darkSurface = Color(0xFF111114); // cards / raised
  static const Color darkSurfaceHi = Color(0xFF17171C); // hover / elevated
  static const Color darkBorder = Color(0x14FFFFFF); // 8% white hairline
  static const Color darkBorderHi = Color(0x2EFFFFFF); // ~18% on hover
  static const Color darkTextPrimary = Color(0xFFEDEDEF);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF6B6B76);

  // --- Light theme (inverse) --------------------------------------------
  static const Color lightBg = Color(0xFFFAFAF9); // warm off-white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHi = Color(0xFFF2F1EF);
  static const Color lightBorder = Color(0x14000000);
  static const Color lightBorderHi = Color(0x24000000);
  static const Color lightTextPrimary = Color(0xFF13131A);
  static const Color lightTextSecondary = Color(0xFF52525B);
  static const Color lightTextTertiary = Color(0xFF9A9AA5);
}
