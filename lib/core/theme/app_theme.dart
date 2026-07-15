import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_palette.dart';
import 'app_typography.dart';

/// Assembles [ThemeData] for both modes, wiring the [AppPalette] extension and
/// the Space Grotesk / Inter / JetBrains Mono type system into Material.
class AppTheme {
  AppTheme._();

  static ThemeData dark() => _build(AppPalette.dark, Brightness.dark);
  static ThemeData light() => _build(AppPalette.light, Brightness.light);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: brightness,
    ).copyWith(
      surface: p.bg,
      primary: p.accentBright,
      onSurface: p.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      textTheme: AppType.textTheme(p.textPrimary, p.textSecondary),
      extensions: [p],
      splashFactory: NoSplash.splashFactory, // custom motion instead of ripple
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}

/// Ergonomic access: `context.palette`, `context.isDark`.
extension PaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  bool get isDark => palette.isDark;
}
