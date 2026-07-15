import 'package:flutter/widgets.dart';

/// Central check for the OS "reduce motion" accessibility setting. When on,
/// entrances resolve instantly and looping/parallax effects hold still.
/// Respecting this is both an accessibility requirement and a senior signal.
bool prefersReducedMotion(BuildContext context) =>
    MediaQuery.maybeOf(context)?.disableAnimations ?? false;
