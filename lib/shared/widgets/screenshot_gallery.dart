import 'package:flutter/material.dart';

import '../../core/responsive/breakpoints.dart';
import 'phone_mockup.dart';

/// Displays a project's screenshots as device mockups, adapting to how many
/// there are with no layout changes required:
///
/// - **0** → a single "screens coming soon" mockup
/// - **1** → one centered device
/// - **2+** → a horizontally scrollable, edge-faded strip of devices
///
/// Drop more images into the project's folder and they simply appear.
class ScreenshotGallery extends StatelessWidget {
  const ScreenshotGallery({super.key, required this.shots});

  final List<String> shots;

  @override
  Widget build(BuildContext context) {
    final height = context.responsive<double>(
      mobile: 340,
      tablet: 400,
      desktop: 440,
    );

    if (shots.isEmpty) {
      return Center(child: PhoneMockup(height: height));
    }
    if (shots.length == 1) {
      return Center(child: PhoneMockup(height: height, imageAsset: shots.first));
    }

    // 2+ → scrollable strip with fading edges.
    return SizedBox(
      height: height + 8,
      child: ShaderMask(
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.04, 0.96, 1.0],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          itemCount: shots.length,
          separatorBuilder: (_, _) => const SizedBox(width: 28),
          itemBuilder: (context, i) => Center(
            child: PhoneMockup(height: height, imageAsset: shots[i]),
          ),
        ),
      ),
    );
  }
}
