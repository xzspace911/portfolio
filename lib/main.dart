import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'app.dart';
import 'core/assets/assets_service.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fire reveal animations the moment a sliver of a section is visible.
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 80);

  // Discover bundled assets (photo, CV, project screenshots) up front so the
  // rest of the app can resolve them synchronously.
  final assets = await AssetsService.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        Provider<AssetsService>.value(value: assets),
      ],
      child: const PortfolioApp(),
    ),
  );
}
