import 'package:flutter/widgets.dart';
import '../design/app_motion.dart';
import 'reveal_on_scroll.dart';

/// Lays out children in a [Flex] where each reveals in sequence as the group
/// scrolls into view — the staggered cascade that makes lists feel authored
/// rather than dumped. For bespoke layouts, wrap items in [RevealOnScroll]
/// directly with a manual `delay`.
class RevealGroup extends StatelessWidget {
  const RevealGroup({
    super.key,
    required this.children,
    this.axis = Axis.vertical,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.step = Motion.stagger,
    this.baseDelay = Duration.zero,
  });

  final List<Widget> children;
  final Axis axis;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Duration step;
  final Duration baseDelay;

  @override
  Widget build(BuildContext context) {
    final wrapped = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0 && spacing > 0) {
        wrapped.add(axis == Axis.vertical
            ? SizedBox(height: spacing)
            : SizedBox(width: spacing));
      }
      wrapped.add(
        RevealOnScroll(
          delay: baseDelay + step * i,
          child: children[i],
        ),
      );
    }
    return Flex(
      direction: axis,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: wrapped,
    );
  }
}
