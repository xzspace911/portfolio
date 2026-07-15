import 'package:flutter/widgets.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/content_container.dart';

/// Standard vertical rhythm + measure for every content section below the
/// hero. Keeps the whole page on one consistent spatial grid.
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.child,
    this.id,
    this.maxWidth = Breakpoints.maxContent,
  });

  final Widget child;
  final Key? id;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final vpad = context.responsive<double>(
      mobile: 88,
      tablet: 112,
      desktop: 144,
    );
    return KeyedSubtree(
      key: id,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vpad),
        child: ContentContainer(maxWidth: maxWidth, child: child),
      ),
    );
  }
}
