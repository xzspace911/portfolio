import 'package:flutter/widgets.dart';

/// Device classes. Layout *adapts* across these — it doesn't merely shrink.
enum DeviceType { mobile, tablet, desktop, wide }

class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  /// Max content width — keeps line lengths readable on ultra-wide monitors
  /// and preserves the intentional, gallery-like composition.
  static const double maxContent = 1200;

  static DeviceType of(double width) {
    if (width < mobile) return DeviceType.mobile;
    if (width < tablet) return DeviceType.tablet;
    if (width < desktop) return DeviceType.desktop;
    return DeviceType.wide;
  }
}

extension DeviceTypeX on DeviceType {
  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isDesktop => this == DeviceType.desktop || this == DeviceType.wide;
  bool get isHandheld => this == DeviceType.mobile || this == DeviceType.tablet;
}

extension ResponsiveContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  DeviceType get device => Breakpoints.of(screenWidth);
  bool get isMobile => device.isMobile;
  bool get isHandheld => device.isHandheld;
  bool get isDesktop => device.isDesktop;

  /// Whether pointer-driven flourishes (magnetic buttons, cursor glow) apply.
  /// Disabled on touch/handheld where they'd be inert or janky.
  bool get supportsPointerFx => isDesktop;

  /// Pick a value per device class with sensible fallbacks.
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? wide,
  }) {
    switch (device) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.wide:
        return wide ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Fluid interpolation between a min and max value across a width range —
/// the Dart equivalent of CSS `clamp()`. Used for hero display sizing.
double fluid(
  double width, {
  required double minW,
  required double maxW,
  required double minV,
  required double maxV,
}) {
  if (width <= minW) return minV;
  if (width >= maxW) return maxV;
  final t = (width - minW) / (maxW - minW);
  return minV + (maxV - minV) * t;
}
