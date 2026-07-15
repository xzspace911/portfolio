/// Lets descendant widgets (e.g. the hero's "View Work" button) request a
/// smooth scroll to a named section without knowing how scrolling works.
/// Provided by [HomePage], which wires it to its scroll logic.
class SectionNav {
  const SectionNav(this._go);
  final void Function(String id) _go;

  /// Scroll to a section anchor: 'work' | 'story' | 'skills' | 'contact' |
  /// 'top'.
  void go(String id) => _go(id);
}
