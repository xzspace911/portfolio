import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/assets/assets_service.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/projects.dart';
import '../../shared/widgets/screenshot_gallery.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';

/// Featured Work — the first content section after the hero. Leads with the
/// three hero case studies (device mockups + problem/solution/challenge), then
/// a compact grid of further projects.
class FeaturedWorkSection extends StatelessWidget {
  const FeaturedWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            index: '01',
            eyebrow: 'SELECTED WORK',
            title: 'Products, shipped to production.',
          ),
          Space.gap64,
          for (var i = 0; i < Project.heroes.length; i++) ...[
            _HeroCase(project: Project.heroes[i], index: i),
            if (i != Project.heroes.length - 1) const _CaseDivider(),
          ],
          Space.gap64,
          const _GridHeader(),
          Space.gap32,
          const _ProjectGrid(),
        ],
      ),
    );
  }
}

class _CaseDivider extends StatelessWidget {
  const _CaseDivider();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.x20),
        child: Divider(color: context.palette.border, height: 1),
      );
}

class _HeroCase extends StatelessWidget {
  const _HeroCase({required this.project, required this.index});
  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final shots = context.read<AssetsService>().projectShots(project.screensDir);
    final isDesktop = context.isDesktop;

    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: index + category + name + tagline.
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${index + 1}'.padLeft(2, '0'),
                  style: AppType.mono(p.accentBright)),
              Space.gap12,
              Expanded(
                child: Wrap(
                  spacing: Space.x2,
                  runSpacing: Space.x2,
                  children: [for (final c in project.category) _Tag(c)],
                ),
              ),
            ],
          ),
          Space.gap16,
          Text(project.name, style: AppType.h2(p.textPrimary)),
          Space.gap12,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(project.tagline, style: AppType.bodyLg(p.textSecondary)),
          ),
          if (project.role != null) ...[
            Space.gap12,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.badge_outlined, size: 15, color: p.textTertiary),
                Space.gap8,
                Text(project.role!, style: AppType.bodySm(p.textTertiary)),
                Space.gap16,
                Icon(Icons.business_outlined, size: 15, color: p.textTertiary),
                Space.gap8,
                Text(project.client, style: AppType.bodySm(p.textTertiary)),
              ],
            ),
          ],
          Space.gap48,
          // Device mockups.
          ScreenshotGallery(shots: shots),
          Space.gap48,
          // Case-study detail.
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _Narrative(project: project)),
                  const SizedBox(width: Space.x16),
                  Expanded(flex: 5, child: _Meta(project: project)),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Narrative(project: project),
                Space.gap32,
                _Meta(project: project),
              ],
            ),
        ],
      ),
    );
  }
}

class _Narrative extends StatelessWidget {
  const _Narrative({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (project.problem != null)
          _Labeled(label: 'THE PROBLEM', body: project.problem!),
        if (project.solution != null) ...[
          Space.gap24,
          _Labeled(label: 'THE SOLUTION', body: project.solution!),
        ],
        if (project.challenge != null) ...[
          Space.gap24,
          _Labeled(label: 'HARDEST CHALLENGE', body: project.challenge!),
        ],
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.project});
  final Project project;

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
          if (project.highlights.isNotEmpty) ...[
            Text('HIGHLIGHTS', style: AppType.mono(p.textTertiary)),
            Space.gap16,
            for (final h in project.highlights) _Bullet(h),
            Space.gap24,
          ],
          if (project.features.isNotEmpty) ...[
            Text('KEY FEATURES', style: AppType.mono(p.textTertiary)),
            Space.gap12,
            Wrap(
              spacing: Space.x2,
              runSpacing: Space.x2,
              children: [for (final f in project.features) _Tag(f)],
            ),
            Space.gap24,
          ],
          if (project.stack.isNotEmpty) ...[
            Text('TECH STACK', style: AppType.mono(p.textTertiary)),
            Space.gap12,
            Wrap(
              spacing: Space.x2,
              runSpacing: Space.x2,
              children: [for (final s in project.stack) _Tag(s, accent: true)],
            ),
          ],
        ],
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.body});
  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppType.mono(p.accentBright)),
        Space.gap8,
        Text(body, style: AppType.body(p.textSecondary)),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
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
            padding: const EdgeInsets.only(top: 7, right: 10),
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                  color: AppColors.violetBright, shape: BoxShape.circle),
            ),
          ),
          Expanded(child: Text(text, style: AppType.bodySm(p.textSecondary))),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, {this.accent = false});
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Space.x3, vertical: Space.x1),
      decoration: BoxDecoration(
        borderRadius: Radii.allPill,
        border: Border.all(
            color: accent
                ? AppColors.violet.withValues(alpha: 0.4)
                : p.border),
        color: accent
            ? AppColors.violet.withValues(alpha: 0.1)
            : p.surface.withValues(alpha: 0.5),
      ),
      child: Text(label,
          style: AppType.bodySm(accent ? AppColors.violetSoft : p.textSecondary)
              .copyWith(fontSize: 12.5)),
    );
  }
}

// --- Grid --------------------------------------------------------------------

class _GridHeader extends StatelessWidget {
  const _GridHeader();
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return RevealOnScroll(
      child: Row(
        children: [
          Text('MORE PROJECTS', style: AppType.mono(p.textSecondary)),
          Space.gap16,
          Expanded(child: Divider(color: p.border, height: 1)),
        ],
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid();

  @override
  Widget build(BuildContext context) {
    final cols = context.isDesktop ? 2 : 1;
    final projects = Project.grid;
    final rows = <Widget>[];
    for (var i = 0; i < projects.length; i += cols) {
      final slice = projects.skip(i).take(cols).toList();
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < slice.length; j++) ...[
              Expanded(child: _GridCard(project: slice[j])),
              if (j != slice.length - 1) const SizedBox(width: Space.x4),
            ],
            if (slice.length < cols) const Spacer(),
          ],
        ),
      ));
      if (i + cols < projects.length) rows.add(const SizedBox(height: Space.x4));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

class _GridCard extends StatefulWidget {
  const _GridCard({required this.project});
  final Project project;

  @override
  State<_GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<_GridCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final proj = widget.project;
    return RevealOnScroll(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: Motion.base,
          curve: Motion.standard,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
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
              Row(
                children: [
                  Expanded(
                    child: Text(proj.name, style: AppType.h3(p.textPrimary)),
                  ),
                  Icon(Icons.arrow_outward_rounded,
                      size: 18,
                      color: _hover ? p.accentBright : p.textTertiary),
                ],
              ),
              Space.gap12,
              Text(proj.tagline, style: AppType.bodySm(p.textSecondary)),
              Space.gap16,
              Wrap(
                spacing: Space.x2,
                runSpacing: Space.x2,
                children: [for (final s in proj.stack) _Tag(s, accent: true)],
              ),
              if (proj.links.isNotEmpty) ...[
                Space.gap16,
                for (final l in proj.links)
                  TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse(l.url)),
                    icon: const Icon(Icons.code, size: 16),
                    label: Text(l.label),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
