import 'package:flutter/material.dart';

import '../../core/design/app_motion.dart';
import '../../core/design/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';

/// A hover-lifting identity/principle card with an accent icon.
class PillarCard extends StatefulWidget {
  const PillarCard(this.pillar, {super.key});
  final Pillar pillar;

  @override
  State<PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<PillarCard> {
  bool _hover = false;

  static const _icons = {
    'design': Icons.brush_outlined,
    'architecture': Icons.account_tree_outlined,
    'performance': Icons.speed_outlined,
    'product': Icons.lightbulb_outline,
  };

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Motion.base,
        curve: Motion.standard,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        padding: const EdgeInsets.all(Space.x6),
        decoration: BoxDecoration(
          borderRadius: Radii.allLg,
          color: _hover ? p.surfaceHi : p.surface,
          border: Border.all(color: _hover ? p.borderHi : p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: Radii.allSm,
                color: AppColors.violet.withValues(alpha: 0.16),
              ),
              child: Icon(_icons[widget.pillar.icon] ?? Icons.circle_outlined,
                  size: 20, color: AppColors.violetSoft),
            ),
            Space.gap16,
            Text(widget.pillar.title, style: AppType.h3(p.textPrimary)),
            Space.gap8,
            Text(widget.pillar.body, style: AppType.bodySm(p.textSecondary)),
          ],
        ),
      ),
    );
  }
}
