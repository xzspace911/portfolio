import 'downloader_stub.dart'
    if (dart.library.js_interop) 'downloader_web.dart';

/// Downloads a bundled asset to the user's device with the given [filename].
///
/// On web this reads the asset bytes and triggers a real browser download via a
/// Blob + object URL (works on desktop and mobile browsers). On non-web
/// targets (including the VM test runner) it is a no-op — the portfolio ships
/// only for web.
Future<void> downloadAsset(String assetPath, String filename) =>
    downloadAssetImpl(assetPath, filename);
