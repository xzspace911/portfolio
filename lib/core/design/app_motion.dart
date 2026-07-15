import 'package:flutter/animation.dart';

/// Motion tokens. The rule: elegant, never excessive. Durations sit in the
/// 200–600ms band; easing favours the "emphasized decelerate" feel that reads
/// as expensive. All scroll-driven reveals honour `prefers-reduced-motion`
/// (handled centrally in the reveal widget).
class Motion {
  Motion._();

  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration base = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration slower = Duration(milliseconds: 640);
  static const Duration loader = Duration(milliseconds: 1100);

  // Stagger step between children in a revealed group.
  static const Duration stagger = Duration(milliseconds: 90);

  // Curves
  /// Emphasized decelerate — the signature ease for entrances.
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Smooth in/out for hovers and toggles.
  static const Curve standard = Curves.easeInOutCubicEmphasized;

  /// Springy-but-controlled for magnetic buttons.
  static const Curve magnetic = Cubic(0.34, 1.35, 0.64, 1.0);
}
