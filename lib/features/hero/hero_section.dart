import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/assets/assets_service.dart';
import '../../core/platform/asset_downloader.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/aurora_background.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/content_container.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';
import '../home/section_nav.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/status_pill.dart';
import 'widgets/portrait_frame.dart';

/// The signature moment: living aurora backdrop, a stagger-revealed headline
/// with a gradient accent line, magnetic CTAs, and the branded portrait.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final minHeight = context.screenHeight;

    return AuroraBackground(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: context.responsive<double>(mobile: 120, desktop: 140),
              bottom: Space.x16,
            ),
            child: ContentContainer(
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 7, child: _HeroCopy()),
                        Space.gap64,
                        const Expanded(
                          flex: 5,
                          child: _RevealPortrait(),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        _HeroCopy(),
                        SizedBox(height: Space.x16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 300,
                            child: _RevealPortrait(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RevealPortrait extends StatelessWidget {
  const _RevealPortrait();

  @override
  Widget build(BuildContext context) {
    return const PortraitFrame()
        .animate()
        .fadeIn(duration: Motion.slower, delay: 400.ms)
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          duration: Motion.slower,
          curve: Motion.emphasized,
        );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final width = context.screenWidth;
    final assets = context.read<AssetsService>();
    final titleSize = fluid(width, minW: 340, maxW: 1440, minV: 38, maxV: 88);

    // Interval between staggered entrance elements.
    const step = 90;
    var i = 0;
    Animate wrap(Widget child) {
      final delay = (i++ * step + 120).ms;
      return child
          .animate()
          .fadeIn(duration: Motion.slow, delay: delay)
          .moveY(begin: 22, end: 0, duration: Motion.slow, curve: Motion.emphasized);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        wrap(StatusPill(label: Profile.availability)),
        Space.gap24,
        wrap(Text(
          '${Profile.name}  ·  ${Profile.role}'.toUpperCase(),
          style: AppType.mono(p.textSecondary),
        )),
        Space.gap16,
        // Two separate, wrappable lines — never a WidgetSpan (which would be an
        // unbreakable inline box and overflow on narrow screens).
        wrap(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Profile.heroTitleTop,
              style: AppType.display(p.textPrimary).copyWith(fontSize: titleSize),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.violetSoft,
                  AppColors.violetBright,
                  AppColors.magenta,
                ],
              ).createShader(bounds),
              child: Text(
                Profile.heroTitleAccent,
                style:
                    AppType.display(Colors.white).copyWith(fontSize: titleSize),
              ),
            ),
          ],
        )),
        Space.gap24,
        wrap(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(Profile.subhook, style: AppType.bodyLg(p.textSecondary)),
        )),
        Space.gap32,
        wrap(Wrap(
          spacing: Space.x4,
          runSpacing: Space.x4,
          children: [
            GradientButton(
              label: 'View Work',
              icon: Icons.arrow_downward_rounded,
              onPressed: () => context.read<SectionNav>().go('work'),
            ),
            if (assets.cvPath != null)
              GhostButton(
                label: 'Download CV',
                icon: Icons.file_download_outlined,
                onPressed: () =>
                    downloadAsset(assets.cvPath!, assets.cvFilename),
              ),
          ],
        )),
        Space.gap32,
        wrap(const _MetaRow()),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget item(IconData icon, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: p.textTertiary),
            Space.gap8,
            Text(label, style: AppType.bodySm(p.textSecondary)),
          ],
        );

    return Wrap(
      spacing: Space.x8,
      runSpacing: Space.x3,
      children: [
        item(Icons.location_on_outlined, Profile.location),
        item(Icons.bolt_outlined, '${Profile.yearsFlutter}+ yrs Flutter'),
        item(Icons.work_outline_rounded, '@ ${Profile.company}'),
      ],
    );
  }
}
