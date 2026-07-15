import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// Centers content within [Breakpoints.maxContent] and applies device-aware
/// horizontal gutters. Every section wraps its content in this so the whole
/// site shares one consistent measure.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final gutter = context.responsive<double>(
      mobile: 24,
      tablet: 48,
      desktop: 64,
      wide: 80,
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth + gutter * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: child,
        ),
      ),
    );
  }
}
