import 'dart:js_interop';

import 'package:flutter/services.dart' show rootBundle;
import 'package:web/web.dart' as web;

/// Web download: read the bundled asset, wrap its bytes in a Blob, and click a
/// temporary anchor with a `download` attribute so the browser saves it with
/// the given [filename]. Works on desktop and mobile browsers without opening
/// a fragile asset URL.
Future<void> downloadAssetImpl(String assetPath, String filename) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();

  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename
    ..style.display = 'none';
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();

  web.URL.revokeObjectURL(url);
}
