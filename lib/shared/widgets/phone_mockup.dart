import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// A premium phone device frame that showcases a single screenshot. The
/// screenshots already include the OS status bar, so the frame is a clean
/// modern bezel (rounded body, thin inner rim, side button, ambient glow) with
/// no notch overlay. Screen aspect matches modern iPhones (~0.462).
class PhoneMockup extends StatelessWidget {
  const PhoneMockup({
    super.key,
    required this.height,
    this.imageAsset,
    this.label,
    this.glow = true,
  });

  final double height;

  /// Screenshot asset path; when null a branded empty screen shows.
  final String? imageAsset;

  /// Optional caption under the phone (e.g. a screen name).
  final String? label;
  final bool glow;

  static const double _screenAspect = 0.462; // width / height

  @override
  Widget build(BuildContext context) {
    final width = height * _screenAspect + 14; // + bezel
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (glow)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(46),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.violet.withValues(alpha: 0.28),
                          blurRadius: 70,
                          spreadRadius: -16,
                          offset: const Offset(0, 26),
                        ),
                      ],
                    ),
                  ),
                ),
              // Titanium-style body.
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(46),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A31), Color(0xFF111114)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ColoredBox(
                    color: Colors.white,
                    child: imageAsset != null
                        ? Image.asset(
                            imageAsset!,
                            fit: BoxFit.cover,
                            cacheWidth: 640,
                            errorBuilder: (_, _, _) => const _EmptyScreen(),
                          )
                        : const _EmptyScreen(),
                  ),
                ),
              ),
              // Side button.
              Positioned(
                right: -2,
                top: height * 0.28,
                child: Container(
                  width: 3,
                  height: height * 0.1,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A42),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 14),
          Text(label!,
              style: AppType.bodySm(context.palette.textTertiary),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  const _EmptyScreen();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.violet, Color(0xFF160B22)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_outlined,
                  color: Colors.white70, size: 28),
              const SizedBox(height: 8),
              Text('Screens\ncoming soon',
                  textAlign: TextAlign.center,
                  style: AppType.mono(Colors.white.withValues(alpha: 0.7))
                      .copyWith(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
