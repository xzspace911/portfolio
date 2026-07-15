import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/assets/assets_service.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/platform/asset_downloader.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/profile.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_shell.dart';

/// Contact — the conversion moment — followed by the footer.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, this.index = '06'});
  final String index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final assets = context.read<AssetsService>();
    final width = context.screenWidth;
    final titleSize = fluid(width, minW: 340, maxW: 1440, minV: 34, maxV: 60);

    return Column(
      children: [
        SectionShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(index: index, eyebrow: 'CONTACT'),
              Space.gap32,
              RevealOnScroll(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Text(
                    Profile.contactTitle,
                    style: AppType.display(p.textPrimary)
                        .copyWith(fontSize: titleSize),
                  ),
                ),
              ),
              Space.gap24,
              RevealOnScroll(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(Profile.contactBody,
                      style: AppType.bodyLg(p.textSecondary)),
                ),
              ),
              Space.gap32,
              RevealOnScroll(
                child: Wrap(
                  spacing: Space.x4,
                  runSpacing: Space.x4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GradientButton(
                      label: 'Email me',
                      icon: Icons.arrow_outward_rounded,
                      onPressed: () => _launch(
                          Uri(scheme: 'mailto', path: Profile.email)),
                    ),
                    if (assets.cvPath != null)
                      GhostButton(
                        label: 'Download CV',
                        icon: Icons.file_download_outlined,
                        onPressed: () =>
                            downloadAsset(assets.cvPath!, assets.cvFilename),
                      ),
                    for (final s in Profile.socials)
                      _SocialLink(link: s),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _Footer(),
      ],
    );
  }
}

void _launch(Uri uri) async {
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

class _SocialLink extends StatefulWidget {
  const _SocialLink({required this.link});
  final SocialLink link;

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => _launch(Uri.parse(widget.link.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
              horizontal: Space.x5, vertical: Space.x4),
          decoration: BoxDecoration(
            borderRadius: Radii.allPill,
            color: _hover ? p.surfaceHi : Colors.transparent,
            border: Border.all(color: _hover ? p.borderHi : p.border),
          ),
          child: Text(widget.link.label,
              style: AppType.button(p.textPrimary)),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.x12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive<double>(
                mobile: 24, tablet: 48, desktop: 64)),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: Space.x4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: Radii.allSm,
                    gradient: const LinearGradient(
                      colors: [AppColors.violet, AppColors.violetBright],
                    ),
                  ),
                  child: Text(Profile.initials,
                      style: AppType.button(Colors.white)
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                Space.gap12,
                Text('© 2026 ${Profile.name}',
                    style: AppType.bodySm(p.textSecondary)),
              ],
            ),
            Text('Designed & built with Flutter Web',
                style: AppType.mono(p.textTertiary)),
          ],
        ),
      ),
    );
  }
}
