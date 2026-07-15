import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../design/app_motion.dart';
import 'reduced_motion.dart';

/// Reveals its child once it scrolls into view: fade + rise + a subtle
/// blur-to-sharp settle. Fires only once, and only past a visibility
/// threshold so it triggers at a natural reading moment.
///
/// If the OS requests reduced motion, the child appears immediately with no
/// transform. [delay] enables manual stagger; prefer [RevealGroup] for lists.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = Motion.slow,
    this.offsetY = 28,
    this.blur = 8,
    this.threshold = 0.12,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;
  final double blur;
  final double threshold;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  bool _fired = false;

  // Stable, unique key for the visibility detector across rebuilds.
  late final Key _vkey = UniqueKey();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _trigger() {
    if (_fired) return;
    _fired = true;
    Future<void>.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (prefersReducedMotion(context)) return widget.child;

    return VisibilityDetector(
      key: _vkey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.threshold) _trigger();
      },
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = Motion.emphasized.transform(_c.value);
          final blurSigma = widget.blur * (1 - t);
          Widget content = Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, widget.offsetY * (1 - t)),
              child: child,
            ),
          );
          // Blur is the most expensive part; skip it once essentially sharp.
          if (blurSigma > 0.4) {
            content = ImageFiltered(
              imageFilter: _blur(blurSigma),
              child: content,
            );
          }
          return content;
        },
        child: widget.child,
      ),
    );
  }
}

// Cheap Gaussian; kept out of build hot path via a top-level helper.
ImageFilter _blur(double sigma) =>
    ImageFilter.blur(sigmaX: sigma, sigmaY: sigma, tileMode: TileMode.decal);
