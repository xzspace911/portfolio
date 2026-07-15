import 'package:flutter/material.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/reveal_on_scroll.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// Indexed section eyebrow (`01 — ABOUT`) with an accent tick, over an
/// optional large title. The mono index signals "engineer"; the reveal-on-
/// scroll entrance keeps the page feeling authored.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.index,
    required this.eyebrow,
    this.title,
  });

  final String index; // e.g. '01'
  final String eyebrow; // e.g. 'ABOUT'
  final String? title;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.violetBright,
                  shape: BoxShape.circle,
                ),
              ),
              Space.gap12,
              Text('$index — $eyebrow', style: AppType.mono(p.textSecondary)),
            ],
          ),
          if (title != null) ...[
            Space.gap24,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(title!, style: AppType.h1(p.textPrimary)),
            ),
          ],
        ],
      ),
    );
  }
}
