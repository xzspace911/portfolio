/// Non-web fallback (VM/tests). The portfolio targets web only, so this is a
/// no-op — it keeps the conditional import compiling off-web.
Future<void> downloadAssetImpl(String assetPath, String filename) async {}
