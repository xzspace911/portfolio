import 'package:flutter/material.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_spacing.dart';
import '../../core/motion/magnetic.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// Primary call-to-action: a violet gradient pill that lifts, brightens its
/// glow, and follows the cursor (magnetic) on hover. The signature button.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Magnetic(
      builder: (context, hovering) {
        return AnimatedScale(
          scale: hovering ? 1.03 : 1.0,
          duration: Motion.base,
          curve: Motion.magnetic,
          child: GestureDetector(
            onTap: onPressed,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: Motion.base,
                curve: Motion.standard,
                padding: const EdgeInsets.symmetric(
                    horizontal: Space.x8, vertical: Space.x5),
                decoration: BoxDecoration(
                  borderRadius: Radii.allPill,
                  gradient: const LinearGradient(
                    colors: [AppColors.violet, AppColors.violetBright],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violetBright
                          .withValues(alpha: hovering ? 0.55 : 0.32),
                      blurRadius: hovering ? 42 : 26,
                      spreadRadius: hovering ? 2 : 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: AppType.button(Colors.white)),
                    if (icon != null) ...[
                      Space.gap8,
                      Icon(icon, size: 17, color: Colors.white),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Secondary action: a hairline "ghost" button that fills faintly on hover.
class GhostButton extends StatefulWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Motion.base,
          curve: Motion.standard,
          padding: const EdgeInsets.symmetric(
              horizontal: Space.x8, vertical: Space.x5),
          decoration: BoxDecoration(
            borderRadius: Radii.allPill,
            color: _hover ? p.surfaceHi : Colors.transparent,
            border: Border.all(color: _hover ? p.borderHi : p.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: AppType.button(p.textPrimary)),
              if (widget.icon != null) ...[
                Space.gap8,
                Icon(widget.icon, size: 17, color: p.textPrimary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
