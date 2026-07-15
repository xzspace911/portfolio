import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reduced_motion.dart';

/// The hero's living backdrop: slow-drifting violet→magenta→indigo gradient
/// "blobs" (Stripe-style depth) blended additively over the near-black canvas,
/// plus a sparse field of floating particles.
///
/// Performance: one [AnimationController], all painting inside a single
/// [RepaintBoundary], particles capped and precomputed. When reduced-motion is
/// on, the field renders once at a fixed phase and never repaints.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    this.particleCount = 46,
    this.child,
  });

  final int particleCount;
  final Widget? child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 26),
  );

  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rnd = math.Random(7); // fixed seed → deterministic, stable field
    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        base: Offset(rnd.nextDouble(), rnd.nextDouble()),
        radius: 0.6 + rnd.nextDouble() * 1.8,
        speed: 0.15 + rnd.nextDouble() * 0.5,
        phase: rnd.nextDouble() * math.pi * 2,
        drift: 0.02 + rnd.nextDouble() * 0.05,
        opacity: 0.10 + rnd.nextDouble() * 0.35,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = prefersReducedMotion(context);
    if (!reduced && !_c.isAnimating) {
      _c.repeat();
    } else if (reduced && _c.isAnimating) {
      _c.stop();
    }

    final palette = context.palette;

    // CustomPaint paints the aurora *behind* its child and sizes itself to the
    // child — no Stack/expand, so it composes correctly inside a sliver. The
    // child is passed through AnimatedBuilder's `child` slot so it is NOT
    // rebuilt on every animation frame (only the painter repaints).
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          return CustomPaint(
            painter: _AuroraPainter(
              t: reduced ? 0.2 : _c.value,
              particles: _particles,
              isDark: palette.isDark,
              stops: palette.meshStops,
            ),
            child: child,
          );
        },
        child: widget.child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.base,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.drift,
    required this.opacity,
  });

  final Offset base; // normalized 0..1 position
  final double radius;
  final double speed;
  final double phase;
  final double drift;
  final double opacity;
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.t,
    required this.particles,
    required this.isDark,
    required this.stops,
  });

  final double t; // 0..1 loop phase
  final List<_Particle> particles;
  final bool isDark;
  final List<Color> stops;

  @override
  void paint(Canvas canvas, Size size) {
    final angle = t * math.pi * 2;
    final blend = isDark ? BlendMode.plus : BlendMode.srcOver;

    // --- Gradient blobs -------------------------------------------------
    // Each blob orbits a home anchor along a gentle Lissajous path.
    _blob(canvas, size, stops[1], // violet
        anchor: const Offset(0.26, 0.30), angle: angle, scale: 0.62,
        blend: blend, alpha: isDark ? 0.55 : 0.22);
    _blob(canvas, size, stops[2], // magenta
        anchor: const Offset(0.78, 0.24), angle: angle + 2.1, scale: 0.5,
        blend: blend, alpha: isDark ? 0.45 : 0.18);
    _blob(canvas, size, stops[0], // indigo
        anchor: const Offset(0.62, 0.72), angle: angle + 4.0, scale: 0.7,
        blend: blend, alpha: isDark ? 0.5 : 0.16);
    _blob(canvas, size, stops[3], // bright violet accent
        anchor: const Offset(0.14, 0.82), angle: angle + 1.2, scale: 0.4,
        blend: blend, alpha: isDark ? 0.4 : 0.14);

    // --- Particles ------------------------------------------------------
    final pPaint = Paint();
    for (final p in particles) {
      final drift = p.drift;
      final x = (p.base.dx + math.sin(angle * p.speed + p.phase) * drift);
      final y = (p.base.dy + math.cos(angle * p.speed + p.phase) * drift);
      final tw = 0.5 + 0.5 * math.sin(angle * (0.8 + p.speed) + p.phase);
      pPaint.color = (isDark ? Colors.white : stops[1])
          .withValues(alpha: p.opacity * (0.4 + 0.6 * tw));
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        pPaint,
      );
    }
  }

  void _blob(
    Canvas canvas,
    Size size,
    Color color, {
    required Offset anchor,
    required double angle,
    required double scale,
    required BlendMode blend,
    required double alpha,
  }) {
    final orbit = size.shortestSide * 0.06;
    final center = Offset(
      anchor.dx * size.width + math.cos(angle) * orbit,
      anchor.dy * size.height + math.sin(angle * 0.8) * orbit,
    );
    final radius = size.shortestSide * scale;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..blendMode = blend
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t || old.isDark != isDark;
}
