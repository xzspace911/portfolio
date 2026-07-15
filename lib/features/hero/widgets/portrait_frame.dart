import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/assets/assets_service.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/motion/reduced_motion.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/profile.dart';

/// The hero portrait — a high-end, framed presentation of Ahmed's photo:
///
/// - Ambient violet glow bleeding behind a glass frame
/// - A gradient hairline border + inner depth
/// - A slow diagonal light **sheen** sweeping across
/// - A gentle continuous **float**
/// - A desktop **pointer-tilt** (subtle 3D parallax toward the cursor)
///
/// The photo is resolved at runtime from [AssetsService] (any `profile.*` in
/// `assets/images/`). If none is present it falls back to a branded
/// placeholder — so the hero always looks intentional.
class PortraitFrame extends StatefulWidget {
  const PortraitFrame({super.key});

  @override
  State<PortraitFrame> createState() => _PortraitFrameState();
}

class _PortraitFrameState extends State<PortraitFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  // Pointer tilt (desktop only), in normalized [-1, 1] range.
  Offset _tilt = Offset.zero;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent e, Size size) {
    setState(() {
      _tilt = Offset(
        (e.localPosition.dx / size.width - 0.5) * 2,
        (e.localPosition.dy / size.height - 0.5) * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduced = prefersReducedMotion(context);
    if (!reduced && !_c.isAnimating) _c.repeat();

    final pointerFx = context.supportsPointerFx && !reduced;
    final photo = context.watch<AssetsService>().profilePhoto;

    Widget frame = AspectRatio(
      aspectRatio: 0.82,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final card = AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              final floatY = reduced ? 0.0 : math.sin(_c.value * math.pi * 2) * 6;
              final tiltX = pointerFx ? -_tilt.dy * 0.06 : 0.0;
              final tiltY = pointerFx ? _tilt.dx * 0.06 : 0.0;
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0012) // perspective
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..translateByDouble(0.0, floatY, 0.0, 1.0);
              return Transform(
                alignment: Alignment.center,
                transform: matrix,
                child: child,
              );
            },
            child: _FrameBody(imageAsset: photo, sheen: _c),
          );

          if (!pointerFx) return card;
          return MouseRegion(
            onHover: (e) => _onHover(e, size),
            onExit: (_) => setState(() => _tilt = Offset.zero),
            child: card,
          );
        },
      ),
    );

    return frame;
  }
}

class _FrameBody extends StatelessWidget {
  const _FrameBody({required this.imageAsset, required this.sheen});

  final String? imageAsset;
  final Animation<double> sheen;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ambient glow behind the frame.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: Radii.allXl,
              boxShadow: [
                BoxShadow(
                  color: AppColors.violet.withValues(alpha: 0.38),
                  blurRadius: 110,
                  spreadRadius: -18,
                  offset: const Offset(0, 34),
                ),
                BoxShadow(
                  color: AppColors.magenta.withValues(alpha: 0.16),
                  blurRadius: 70,
                  spreadRadius: -20,
                  offset: const Offset(-20, -10),
                ),
              ],
            ),
          ),
        ),
        // Gradient hairline border wrapper.
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(1.2),
            decoration: BoxDecoration(
              borderRadius: Radii.allXl,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.violetSoft.withValues(alpha: 0.5),
                  p.border,
                  AppColors.violetBright.withValues(alpha: 0.28),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The photo (or branded fallback when none is bundled).
                  if (imageAsset != null)
                    Image.asset(
                      imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _BrandedPlaceholder(),
                    )
                  else
                    const _BrandedPlaceholder(),
                  // Bottom scrim for depth + legibility of any overlay.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x660A0A0B)],
                        stops: [0.55, 1.0],
                      ),
                    ),
                  ),
                  // Diagonal light sheen sweeping across.
                  AnimatedBuilder(
                    animation: sheen,
                    builder: (context, _) {
                      final t = sheen.value;
                      return IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1.4 + t * 3.2, -1),
                              end: Alignment(-0.4 + t * 3.2, 1),
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.06),
                                Colors.transparent,
                              ],
                              stops: const [0.35, 0.5, 0.65],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandedPlaceholder extends StatelessWidget {
  const _BrandedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.3, -0.5),
              radius: 1.2,
              colors: [AppColors.violet, AppColors.indigo, Color(0xFF0B0712)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Profile.initials,
                style: AppType.display(Colors.white)
                    .copyWith(fontSize: 96, letterSpacing: -4),
              ),
              Space.gap8,
              Text('PORTRAIT',
                  style: AppType.mono(Colors.white.withValues(alpha: 0.5))),
            ],
          ),
        ),
      ],
    );
  }
}
