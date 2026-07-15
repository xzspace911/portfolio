import 'package:flutter/material.dart';

import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/content_container.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';

/// The credibility strip: four self-verifiable headline figures between two
/// hairlines, plus the current role. First thing a skimming recruiter reads
/// after the hero.
class ProofBand extends StatelessWidget {
  const ProofBand({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isHandheld = context.isHandheld;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: p.border),
          bottom: BorderSide(color: p.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.x16),
        child: ContentContainer(
          child: RevealOnScroll(
            child: isHandheld
                ? Wrap(
                    spacing: Space.x8,
                    runSpacing: Space.x10,
                    children: [
                      for (final s in Profile.stats)
                        SizedBox(
                          width: (context.screenWidth < 420) ? 120 : 150,
                          child: _StatBlock(stat: s),
                        ),
                    ],
                  )
                : Row(
                    children: [
                      for (var i = 0; i < Profile.stats.length; i++) ...[
                        Expanded(child: _StatBlock(stat: Profile.stats[i])),
                        if (i != Profile.stats.length - 1)
                          Container(
                            width: 1,
                            height: 52,
                            color: p.border,
                          ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.stat});
  final Stat stat;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.violetSoft, AppColors.violetBright],
          ).createShader(b),
          child: Text(
            stat.value,
            style: AppType.h1(Colors.white).copyWith(fontSize: 44),
          ),
        ),
        Space.gap8,
        Text(stat.label, style: AppType.bodySm(p.textSecondary)),
      ],
    );
  }
}
