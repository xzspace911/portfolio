import 'package:flutter/material.dart';

import '../../core/design/app_motion.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';

/// The Story — who Ahmed is, then how he grew. Opens with the design×
/// engineering identity (folded in from "About"), then a vertical growth
/// timeline whose "ownership" meter fills as it descends, making the arc from
/// *learning* to *owning production systems* tangible.
class JourneySection extends StatelessWidget {
  const JourneySection({super.key, this.index = '03'});
  final String index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SectionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            index: index,
            eyebrow: 'STORY',
            title: Profile.aboutLead,
          ),
          Space.gap32,
          // Identity narrative (folded in from About).
          RevealOnScroll(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < Profile.aboutBody.length; i++) ...[
                    Text(Profile.aboutBody[i],
                        style: AppType.bodyLg(p.textSecondary)),
                    if (i != Profile.aboutBody.length - 1) Space.gap16,
                  ],
                  Space.gap24,
                  Wrap(
                    spacing: Space.x2,
                    runSpacing: Space.x2,
                    children: [for (final l in Profile.languages) _Chip(l)],
                  ),
                ],
              ),
            ),
          ),
          Space.gap64,
          // Timeline sub-header.
          RevealOnScroll(
            child: Row(
              children: [
                Text('THE JOURNEY', style: AppType.mono(p.textSecondary)),
                Space.gap16,
                Expanded(child: Divider(color: p.border, height: 1)),
              ],
            ),
          ),
          Space.gap32,
          RevealOnScroll(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(Profile.journeyIntro,
                  style: AppType.bodyLg(p.textSecondary)),
            ),
          ),
          Space.gap48,
          for (var i = 0; i < Profile.milestones.length; i++)
            RevealOnScroll(
              delay: Motion.stagger * i,
              child: _MilestoneRow(
                milestone: Profile.milestones[i],
                isFirst: i == 0,
                isLast: i == Profile.milestones.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.milestone,
    required this.isFirst,
    required this.isLast,
  });

  final Milestone milestone;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final railWidth = context.isMobile ? 44.0 : 64.0;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: railWidth,
            child: CustomPaint(
              painter: _RailPainter(
                isFirst: isFirst,
                isLast: isLast,
                ownership: milestone.ownership,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Space.x10),
              child: _MilestoneCard(milestone: milestone),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints the continuous timeline spine + this milestone's node. Node fill and
/// glow scale with ownership, so the rail literally brightens as it descends.
class _RailPainter extends CustomPainter {
  _RailPainter({
    required this.isFirst,
    required this.isLast,
    required this.ownership,
  });

  final bool isFirst;
  final bool isLast;
  final double ownership;

  static const double _nodeY = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final line = Paint()
      ..color = const Color(0x24FFFFFF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Segment above the node (skip for the first milestone).
    if (!isFirst) canvas.drawLine(Offset(cx, 0), Offset(cx, _nodeY - 7), line);
    // Segment below the node (skip for the last milestone).
    if (!isLast) {
      canvas.drawLine(Offset(cx, _nodeY + 7), Offset(cx, size.height), line);
    }

    final node = Offset(cx, _nodeY);
    final accent = Color.lerp(
      AppColors.violet,
      AppColors.violetSoft,
      ownership,
    )!;

    // Glow grows with ownership.
    canvas.drawCircle(
      node,
      6 + ownership * 6,
      Paint()
        ..color = accent.withValues(alpha: 0.25 + ownership * 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Outer ring.
    canvas.drawCircle(
      node,
      6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent,
    );
    // Inner fill.
    canvas.drawCircle(node, 3, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(_RailPainter old) =>
      old.ownership != ownership ||
      old.isFirst != isFirst ||
      old.isLast != isLast;
}

class _MilestoneCard extends StatefulWidget {
  const _MilestoneCard({required this.milestone});
  final Milestone milestone;

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final m = widget.milestone;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Motion.base,
        curve: Motion.standard,
        transform: Matrix4.translationValues(_hover ? 6 : 0, 0, 0),
        padding: const EdgeInsets.all(Space.x6),
        decoration: BoxDecoration(
          borderRadius: Radii.allLg,
          color: _hover ? p.surfaceHi : p.surface.withValues(alpha: 0.6),
          border: Border.all(color: _hover ? p.borderHi : p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.x4,
              runSpacing: Space.x2,
              children: [
                Text(m.era.toUpperCase(), style: AppType.mono(p.accentBright)),
                _OwnershipMeter(value: m.ownership, label: m.ownershipLabel),
              ],
            ),
            Space.gap12,
            Text(m.title, style: AppType.h3(p.textPrimary)),
            Space.gap8,
            Text(m.body, style: AppType.bodySm(p.textSecondary)),
            if (m.tags.isNotEmpty) ...[
              Space.gap16,
              Wrap(
                spacing: Space.x2,
                runSpacing: Space.x2,
                children: [for (final t in m.tags) _Chip(t)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A slim gradient bar whose fill encodes ownership, with a caption.
class _OwnershipMeter extends StatelessWidget {
  const _OwnershipMeter({required this.value, required this.label});
  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 64,
          height: 6,
          child: ClipRRect(
            borderRadius: Radii.allPill,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: p.surfaceHi),
                ),
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.violet, AppColors.violetBright],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Space.gap8,
        Text(label, style: AppType.bodySm(p.textTertiary)),
      ],
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
          const EdgeInsets.symmetric(horizontal: Space.x3, vertical: Space.x1),
      decoration: BoxDecoration(
        borderRadius: Radii.allPill,
        border: Border.all(color: p.border),
        color: AppColors.violet.withValues(alpha: 0.08),
      ),
      child: Text(label,
          style: AppType.bodySm(p.textSecondary).copyWith(fontSize: 12.5)),
    );
  }
}
