import 'package:flutter/material.dart';

import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';

/// Skills & Tech Stack — grouped, scannable capability wall.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, this.index = '04'});
  final String index;

  @override
  Widget build(BuildContext context) {
    final cols = context.responsive<int>(mobile: 1, tablet: 2, desktop: 3);
    final groups = Profile.skillGroups;
    final rows = <Widget>[];
    for (var i = 0; i < groups.length; i += cols) {
      final slice = groups.skip(i).take(cols).toList();
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < slice.length; j++) ...[
              Expanded(child: _GroupCard(group: slice[j])),
              if (j != slice.length - 1) const SizedBox(width: Space.x4),
            ],
            for (var k = slice.length; k < cols; k++) ...[
              const SizedBox(width: Space.x4),
              const Spacer(),
            ],
          ],
        ),
      ));
      if (i + cols < groups.length) rows.add(const SizedBox(height: Space.x4));
    }

    return SectionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: index,
            eyebrow: 'SKILLS & STACK',
            title: 'The tools I reach for.',
          ),
          Space.gap48,
          RevealOnScroll(
            child: Column(mainAxisSize: MainAxisSize.min, children: rows),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});
  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(Space.x6),
      decoration: BoxDecoration(
        borderRadius: Radii.allLg,
        color: p.surface.withValues(alpha: 0.6),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(group.title.toUpperCase(), style: AppType.mono(p.accentBright)),
          Space.gap16,
          Wrap(
            spacing: Space.x2,
            runSpacing: Space.x2,
            children: [for (final s in group.items) _Chip(s)],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Space.x3, vertical: Space.x2),
      decoration: BoxDecoration(
        borderRadius: Radii.allSm,
        border: Border.all(color: p.border),
        color: AppColors.violet.withValues(alpha: 0.06),
      ),
      child: Text(label,
          style: AppType.bodySm(p.textSecondary).copyWith(fontSize: 13)),
    );
  }
}
