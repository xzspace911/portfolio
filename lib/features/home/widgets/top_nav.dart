import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/app_motion.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/content_container.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../data/profile.dart';

/// Nav destinations: display label → section anchor id used by [HomePage].
const _navItems = <(String, String)>[
  ('Work', 'work'),
  ('Story', 'story'),
  ('Skills', 'skills'),
  ('Contact', 'contact'),
];

/// Floating glass navigation. Condenses (stronger blur/border) once the page
/// scrolls. Links smooth-scroll to sections via [onNavigate]; on handheld the
/// links collapse into a menu sheet. Tapping the wordmark returns to the top.
class TopNav extends StatelessWidget {
  const TopNav({super.key, required this.scrolled, required this.onNavigate});

  final bool scrolled;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final showLinks = context.isDesktop;

    return AnimatedContainer(
      duration: Motion.base,
      curve: Motion.standard,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: scrolled ? p.border : Colors.transparent),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: scrolled ? 18 : 0,
            sigmaY: scrolled ? 18 : 0,
          ),
          child: Container(
            color:
                scrolled ? p.bg.withValues(alpha: 0.55) : Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: Space.x4),
            child: ContentContainer(
              child: Row(
                children: [
                  _Wordmark(onTap: () => onNavigate('top')),
                  const Spacer(),
                  if (showLinks) ...[
                    for (final (label, id) in _navItems)
                      _NavLink(label, onTap: () => onNavigate(id)),
                    Space.gap24,
                    const _ThemeToggle(),
                  ] else ...[
                    const _ThemeToggle(),
                    Space.gap12,
                    _MenuButton(onNavigate: onNavigate),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: Radii.allSm,
                gradient: const LinearGradient(
                  colors: [AppColors.violet, AppColors.violetBright],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                Profile.initials,
                style: AppType.button(Colors.white).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Space.gap12,
            Text(
              Profile.handle,
              style: AppType.h3(p.textPrimary).copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.x3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppType.body(
                  _hover ? p.textPrimary : p.textSecondary,
                ).copyWith(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: Motion.fast,
                height: 1.5,
                width: _hover ? 16 : 0,
                decoration: const BoxDecoration(
                  color: AppColors.violetBright,
                  borderRadius: Radii.allPill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    final p = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: controller.toggle,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.surface.withValues(alpha: 0.5),
            border: Border.all(color: p.border),
          ),
          child: AnimatedSwitcher(
            duration: Motion.base,
            transitionBuilder: (child, anim) => RotationTransition(
              turns: Tween(begin: 0.6, end: 1.0).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Icon(
              controller.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              key: ValueKey(controller.isDark),
              size: 18,
              color: p.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Handheld menu: opens a glassy sheet of destinations.
class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onNavigate});
  final ValueChanged<String> onNavigate;

  Future<void> _open(BuildContext context) async {
    final p = context.palette;
    final id = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(Space.x4),
        padding: const EdgeInsets.symmetric(vertical: Space.x4),
        decoration: BoxDecoration(
          borderRadius: Radii.allXl,
          color: p.surface,
          border: Border.all(color: p.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (label, anchor) in _navItems)
              ListTile(
                title: Text(label, style: AppType.h3(p.textPrimary)),
                trailing: Icon(Icons.arrow_outward_rounded,
                    color: p.textTertiary, size: 18),
                onTap: () => Navigator.of(ctx).pop(anchor),
              ),
          ],
        ),
      ),
    );
    if (id != null) onNavigate(id);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: p.surface.withValues(alpha: 0.5),
          border: Border.all(color: p.border),
        ),
        child: Icon(Icons.menu_rounded, size: 20, color: p.textPrimary),
      ),
    );
  }
}
