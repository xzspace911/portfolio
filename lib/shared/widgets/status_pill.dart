import 'package:flutter/material.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/reduced_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// A glassy pill with a softly pulsing green dot — the "available" signal that
/// sits above the hero headline. Recruiters read availability instantly.
class StatusPill extends StatefulWidget {
  const StatusPill({super.key, required this.label});
  final String label;

  @override
  State<StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<StatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final reduced = prefersReducedMotion(context);
    const green = Color(0xFF35D07F);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Space.x4, vertical: Space.x2),
      decoration: BoxDecoration(
        borderRadius: Radii.allPill,
        color: p.surface.withValues(alpha: 0.6),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: reduced
                ? const _Dot(color: green, scale: 1)
                : AnimatedBuilder(
                    animation: _c,
                    builder: (_, _) => _Dot(
                      color: green,
                      scale: 0.8 + _c.value * 0.5,
                    ),
                  ),
          ),
          Space.gap8,
          Text(widget.label.toUpperCase(), style: AppType.mono(p.textSecondary)),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.scale});
  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.6),
              blurRadius: 8 * scale,
              spreadRadius: 1.5 * scale,
            ),
          ],
        ),
      ),
    );
  }
}
