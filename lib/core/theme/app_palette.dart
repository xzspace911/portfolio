import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A [ThemeExtension] exposing the full brand palette (including brand-specific
/// tokens Material's [ColorScheme] doesn't model — hairline borders, tertiary
/// text, the violet gradient stops). Access anywhere via
/// `Theme.of(context).extension<AppPalette>()!` or the `context.palette` getter.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.surface,
    required this.surfaceHi,
    required this.border,
    required this.borderHi,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentBright,
    required this.isDark,
  });

  final Color bg;
  final Color surface;
  final Color surfaceHi;
  final Color border;
  final Color borderHi;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentBright;
  final bool isDark;

  /// The signature violet → magenta → indigo mesh used in the hero and
  /// section accents (Stripe-style depth, never a flat fill).
  List<Color> get meshStops => const [
        AppColors.indigo,
        AppColors.violet,
        AppColors.magenta,
        AppColors.violetBright,
      ];

  static const AppPalette dark = AppPalette(
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    surfaceHi: AppColors.darkSurfaceHi,
    border: AppColors.darkBorder,
    borderHi: AppColors.darkBorderHi,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    accent: AppColors.violet,
    accentBright: AppColors.violetBright,
    isDark: true,
  );

  static const AppPalette light = AppPalette(
    bg: AppColors.lightBg,
    surface: AppColors.lightSurface,
    surfaceHi: AppColors.lightSurfaceHi,
    border: AppColors.lightBorder,
    borderHi: AppColors.lightBorderHi,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
    accent: AppColors.violet,
    accentBright: AppColors.violetBright,
    isDark: false,
  );

  @override
  AppPalette copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceHi,
    Color? border,
    Color? borderHi,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentBright,
    bool? isDark,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceHi: surfaceHi ?? this.surfaceHi,
      border: border ?? this.border,
      borderHi: borderHi ?? this.borderHi,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentBright: accentBright ?? this.accentBright,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHi: Color.lerp(surfaceHi, other.surfaceHi, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderHi: Color.lerp(borderHi, other.borderHi, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentBright: Color.lerp(accentBright, other.accentBright, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
