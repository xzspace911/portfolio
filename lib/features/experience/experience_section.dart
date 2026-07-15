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

/// Work Experience — professional roles and responsibilities, distinct from
/// the project case studies (Featured Work) and the personal Story.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key, this.index = '02'});
  final String index;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: index,
            eyebrow: 'EXPERIENCE',
            title: 'Where I’ve done the work.',
          ),
          Space.gap48,
          for (var i = 0; i < Profile.experiences.length; i++) ...[
            RevealOnScroll(child: _ExperienceCard(exp: Profile.experiences[i])),
            if (i != Profile.experiences.length - 1) Space.gap24,
          ],
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.exp});
  final Experience exp;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isDesktop = context.isDesktop;

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(exp.company, style: AppType.h3(p.textPrimary)),
            if (exp.current) ...[
              Space.gap12,
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Space.x3, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: Radii.allPill,
                  color: const Color(0xFF35D07F).withValues(alpha: 0.14),
                  border: Border.all(
                      color: const Color(0xFF35D07F).withValues(alpha: 0.4)),
                ),
                child: Text('CURRENT',
                    style: AppType.mono(const Color(0xFF35D07F))
                        .copyWith(fontSize: 10)),
              ),
            ],
          ],
        ),
        Space.gap4,
        Text(exp.role, style: AppType.body(p.accentBright)),
        Space.gap8,
        Text(exp.period, style: AppType.mono(p.textTertiary)),
      ],
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(exp.summary, style: AppType.bodyLg(p.textSecondary)),
        Space.gap16,
        for (final pt in exp.points) _Point(pt),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(Space.x8),
      decoration: BoxDecoration(
        borderRadius: Radii.allLg,
        color: p.surface.withValues(alpha: 0.6),
        border: Border.all(color: p.border),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: left),
                const SizedBox(width: Space.x12),
                Expanded(flex: 7, child: right),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [left, const SizedBox(height: Space.x6), right],
            ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                  color: AppColors.violetBright, shape: BoxShape.circle),
            ),
          ),
          Expanded(child: Text(text, style: AppType.body(p.textSecondary))),
        ],
      ),
    );
  }
}
