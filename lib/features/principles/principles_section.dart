import 'package:flutter/material.dart';

import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';
import '../../shared/widgets/pillar_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';

/// Engineering Principles — how Ahmed thinks about building software. A lead
/// statement, a set of "prefer X over Y" trade-offs, the four working pillars,
/// and a closing note on working beyond the code.
class PrinciplesSection extends StatelessWidget {
  const PrinciplesSection({super.key, this.index = '05'});
  final String index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isDesktop = context.isDesktop;

    return SectionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: index,
            eyebrow: Profile.principlesEyebrow,
            title: Profile.principlesTitle,
          ),
          Space.gap48,
          // Lead statement + trade-offs.
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 5, child: _Lead()),
                  SizedBox(width: Space.x16),
                  Expanded(flex: 6, child: _Tradeoffs()),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                _Lead(),
                SizedBox(height: Space.x12),
                _Tradeoffs(),
              ],
            ),
          Space.gap48,
          const _Pillars(),
          Space.gap48,
          RevealOnScroll(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Text(Profile.philosophyClose,
                  style: AppType.bodyLg(p.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lead extends StatelessWidget {
  const _Lead();
  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Text(Profile.philosophyLead,
            style: AppType.h3(context.palette.textPrimary)),
      ),
    );
  }
}

class _Tradeoffs extends StatelessWidget {
  const _Tradeoffs();
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return RevealOnScroll(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < Profile.tradeoffs.length; i++) ...[
            _TradeoffRow(Profile.tradeoffs[i]),
            if (i != Profile.tradeoffs.length - 1)
              Divider(color: p.border, height: Space.x8),
          ],
        ],
      ),
    );
  }
}

class _TradeoffRow extends StatelessWidget {
  const _TradeoffRow(this.t);
  final Tradeoff t;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Icon(Icons.check_circle_outline, size: 18, color: AppColors.violetSoft),
        Space.gap12,
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Space.x2,
            children: [
              Text(t.prefer, style: AppType.h3(p.textPrimary).copyWith(fontSize: 18)),
              Text('over', style: AppType.bodySm(p.textTertiary)),
              Text(t.over,
                  style: AppType.body(p.textTertiary).copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: p.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pillars extends StatelessWidget {
  const _Pillars();
  @override
  Widget build(BuildContext context) {
    final cols = context.responsive<int>(mobile: 1, tablet: 2, desktop: 4);
    final pillars = Profile.pillars;
    final rows = <Widget>[];
    for (var i = 0; i < pillars.length; i += cols) {
      final slice = pillars.skip(i).take(cols).toList();
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < slice.length; j++) ...[
              Expanded(child: PillarCard(slice[j])),
              if (j != slice.length - 1) const SizedBox(width: Space.x4),
            ],
            for (var k = slice.length; k < cols; k++) ...[
              const SizedBox(width: Space.x4),
              const Spacer(),
            ],
          ],
        ),
      ));
      if (i + cols < pillars.length) rows.add(const SizedBox(height: Space.x4));
    }
    return RevealOnScroll(
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}
