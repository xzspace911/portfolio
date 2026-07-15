import 'package:flutter/services.dart';

/// Discovers bundled assets at startup by reading the [AssetManifest], so
/// content is fully **drop-in**: add a photo, a CV, or project screenshots to
/// the `assets/` folders, rebuild, and they appear — no code changes.
///
/// Loaded once in `main()` and provided to the tree. All lookups are then
/// synchronous.
class AssetsService {
  AssetsService._(this._keys);

  /// An empty service (no discovered assets) — for tests and safe fallback.
  factory AssetsService.empty() => AssetsService._(const []);

  final List<String> _keys;

  static const _imageExt = ['.jpg', '.jpeg', '.png', '.webp'];

  static Future<AssetsService> load() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return AssetsService._(manifest.listAssets());
    } catch (_) {
      // If the manifest can't be read, degrade gracefully to placeholders.
      return AssetsService._(const []);
    }
  }

  bool _isImage(String k) {
    final lower = k.toLowerCase();
    return _imageExt.any(lower.endsWith);
  }

  /// The profile photo — first image named `profile.*` in `assets/images/`.
  /// Returns null when absent (portrait falls back to the branded placeholder).
  String? get profilePhoto {
    final matches = _keys
        .where((k) =>
            k.startsWith('assets/images/') &&
            _fileName(k).toLowerCase().startsWith('profile') &&
            _isImage(k))
        .toList();
    return matches.isEmpty ? null : matches.first;
  }

  /// The CV — first PDF in `assets/documents/`. Null when absent.
  String? get cvPath {
    final matches = _keys
        .where((k) =>
            k.startsWith('assets/documents/') &&
            k.toLowerCase().endsWith('.pdf'))
        .toList();
    return matches.isEmpty ? null : matches.first;
  }

  /// Filename a downloaded CV should use (defaults to the real file's name).
  String get cvFilename {
    final p = cvPath;
    return p == null ? 'CV.pdf' : _fileName(p);
  }

  /// All screenshots for a project folder (e.g. `assets/projects_screens/fozdoc/`),
  /// sorted naturally so `1, 2, 10` order correctly. Empty when none present.
  List<String> projectShots(String projectDir) {
    final dir = projectDir.endsWith('/') ? projectDir : '$projectDir/';
    final shots = _keys.where((k) => k.startsWith(dir) && _isImage(k)).toList();
    shots.sort(_naturalCompare);
    return shots;
  }

  String _fileName(String key) => key.split('/').last;

  /// Natural sort so `2.PNG` precedes `10.PNG` and `01.jpg` orders sanely.
  int _naturalCompare(String a, String b) {
    final na = _leadingNumber(_fileName(a));
    final nb = _leadingNumber(_fileName(b));
    if (na != null && nb != null && na != nb) return na.compareTo(nb);
    return _fileName(a).toLowerCase().compareTo(_fileName(b).toLowerCase());
  }

  int? _leadingNumber(String name) {
    final match = RegExp(r'^(\d+)').firstMatch(name);
    return match == null ? null : int.tryParse(match.group(1)!);
  }
}
