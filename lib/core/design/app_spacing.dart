import 'package:flutter/widgets.dart';

/// Spacing scale on a 4px base — the rhythmic backbone of the layout.
/// Generous whitespace is a deliberate premium signal (Apple / Vercel).
class Space {
  Space._();

  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x16 = 64;
  static const double x20 = 80;
  static const double x24 = 96;
  static const double x32 = 128;
  static const double x40 = 160;

  // Common SizedBox helpers (const, zero-alloc reuse).
  static const gap4 = SizedBox(height: x1, width: x1);
  static const gap8 = SizedBox(height: x2, width: x2);
  static const gap12 = SizedBox(height: x3, width: x3);
  static const gap16 = SizedBox(height: x4, width: x4);
  static const gap24 = SizedBox(height: x6, width: x6);
  static const gap32 = SizedBox(height: x8, width: x8);
  static const gap48 = SizedBox(height: x12, width: x12);
  static const gap64 = SizedBox(height: x16, width: x16);
}

/// Corner radii — soft but restrained (never bubbly).
class Radii {
  Radii._();

  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(14);
  static const Radius lg = Radius.circular(20);
  static const Radius xl = Radius.circular(28);
  static const Radius pill = Radius.circular(999);

  static const BorderRadius allSm = BorderRadius.all(sm);
  static const BorderRadius allMd = BorderRadius.all(md);
  static const BorderRadius allLg = BorderRadius.all(lg);
  static const BorderRadius allXl = BorderRadius.all(xl);
  static const BorderRadius allPill = BorderRadius.all(pill);
}
