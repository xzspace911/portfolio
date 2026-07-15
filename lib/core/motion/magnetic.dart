import 'package:flutter/widgets.dart';
import '../design/app_motion.dart';
import '../responsive/breakpoints.dart';

/// Wraps a child so it drifts toward the cursor while hovered, then springs
/// back on exit — the "magnetic button" feel. Auto-disables on touch/handheld
/// (where there's no pointer) via [ResponsiveContextX.supportsPointerFx].
///
/// Exposes hover state to [builder] so callers can layer glow/scale on top.
class Magnetic extends StatefulWidget {
  const Magnetic({
    super.key,
    required this.builder,
    this.strength = 0.35,
    this.maxOffset = 14,
  });

  /// Receives whether the pointer is hovering; returns the visual.
  final Widget Function(BuildContext context, bool hovering) builder;

  /// How strongly the child follows the pointer (0–1 of the local delta).
  final double strength;

  /// Clamp on travel distance in logical pixels.
  final double maxOffset;

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic> {
  Offset _offset = Offset.zero;
  bool _hovering = false;
  final _key = GlobalKey();

  void _onHover(PointerEvent e) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    final local = box.globalToLocal(e.position);
    final dx = (local.dx - size.width / 2) * widget.strength;
    final dy = (local.dy - size.height / 2) * widget.strength;
    final clamped = Offset(
      dx.clamp(-widget.maxOffset, widget.maxOffset),
      dy.clamp(-widget.maxOffset, widget.maxOffset),
    );
    if (clamped != _offset) setState(() => _offset = clamped);
  }

  @override
  Widget build(BuildContext context) {
    if (!context.supportsPointerFx) {
      return widget.builder(context, false);
    }
    return MouseRegion(
      key: _key,
      onEnter: (_) => setState(() => _hovering = true),
      onHover: _onHover,
      onExit: (_) => setState(() {
        _hovering = false;
        _offset = Offset.zero;
      }),
      child: AnimatedContainer(
        duration: _hovering ? Motion.fast : Motion.base,
        curve: Motion.magnetic,
        transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0),
        transformAlignment: Alignment.center,
        child: widget.builder(context, _hovering),
      ),
    );
  }
}
