import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type system.
///
/// - **Space Grotesk** — display/headlines: geometric with character, not the
///   overused Inter-everywhere look.
/// - **Inter** — body/UI: proven legibility across weights.
/// - **JetBrains Mono** — section indices, tech labels, code. Signals "engineer".
///
/// Type *is* the design here: big, confident, tight tracking on display,
/// generous line-height on body. Sizes are base values; the responsive layer
/// scales the hero display fluidly.
class AppType {
  AppType._();

  static TextStyle display(Color color) => GoogleFonts.spaceGrotesk(
        color: color,
        fontSize: 76,
        height: 1.02,
        fontWeight: FontWeight.w700,
        letterSpacing: -2.2,
      );

  static TextStyle h1(Color color) => GoogleFonts.spaceGrotesk(
        color: color,
        fontSize: 48,
        height: 1.06,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
      );

  static TextStyle h2(Color color) => GoogleFonts.spaceGrotesk(
        color: color,
        fontSize: 34,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
      );

  static TextStyle h3(Color color) => GoogleFonts.spaceGrotesk(
        color: color,
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      );

  static TextStyle bodyLg(Color color) => GoogleFonts.inter(
        color: color,
        fontSize: 19,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
      );

  static TextStyle body(Color color) => GoogleFonts.inter(
        color: color,
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
      );

  static TextStyle bodySm(Color color) => GoogleFonts.inter(
        color: color,
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      );

  static TextStyle button(Color color) => GoogleFonts.inter(
        color: color,
        fontSize: 15,
        height: 1.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  /// Mono, uppercased, wide-tracked — section eyebrows like `01 — ABOUT`.
  static TextStyle mono(Color color) => GoogleFonts.jetBrainsMono(
        color: color,
        fontSize: 12.5,
        height: 1.2,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
      );

  /// Full Material [TextTheme] built from the ramp for widget defaults.
  static TextTheme textTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: display(primary),
        headlineLarge: h1(primary),
        headlineMedium: h2(primary),
        headlineSmall: h3(primary),
        bodyLarge: bodyLg(secondary),
        bodyMedium: body(secondary),
        bodySmall: bodySm(secondary),
        labelLarge: button(primary),
        labelSmall: mono(secondary),
      );
}
