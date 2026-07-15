import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:portfolio/app.dart';
import 'package:portfolio/core/assets/assets_service.dart';
import 'package:portfolio/core/theme/theme_controller.dart';

/// Pumps the full app with the providers it expects and returns the theme
/// controller for assertions.
Future<ThemeController> pumpApp(
  WidgetTester tester, {
  Size size = const Size(1440, 1024),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  final controller = ThemeController();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(value: controller),
        Provider<AssetsService>.value(value: AssetsService.empty()),
      ],
      child: const PortfolioApp(),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
  return controller;
}

/// Scrolls the main list in steps until [text] is built, then flushes timers.
/// A layout crash in any lazily-built sliver would throw during these frames.
Future<void> scrollTo(WidgetTester tester, String text, {int max = 60}) async {
  final scrollable = find.byType(Scrollable).first;
  for (var i = 0; i < max && find.text(text).evaluate().isEmpty; i++) {
    await tester.drag(scrollable, const Offset(0, -600));
    await tester.pump(const Duration(milliseconds: 60));
  }
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('Hero renders the headline and CTAs', (tester) async {
    await pumpApp(tester);
    expect(find.text('to production.'), findsOneWidget);
    expect(find.text('View Work'), findsOneWidget);
    // "Download CV" is conditional on a bundled CV; AssetsService.empty() has
    // none, so it is intentionally absent here.
    expect(find.text('Download CV'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Featured Work builds and shows a hero project', (tester) async {
    await pumpApp(tester, size: const Size(1440, 1000));
    await scrollTo(tester, 'FozDoc');
    expect(find.text('FozDoc'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Story / Journey builds and scrolls into view', (tester) async {
    await pumpApp(tester, size: const Size(1440, 1000));
    await scrollTo(tester, 'Choosing Flutter');
    expect(find.text('Choosing Flutter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Engineering Principles builds and scrolls into view',
      (tester) async {
    await pumpApp(tester, size: const Size(1440, 1000));
    await scrollTo(tester, 'Design-minded');
    expect(find.text('Design-minded'), findsOneWidget);
    expect(find.text('Scalable architecture'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Nav link scrolls the page down to its section', (tester) async {
    await pumpApp(tester);
    final scrollable = find.byType(Scrollable).first;

    final before = tester.state<ScrollableState>(scrollable).position.pixels;
    expect(before, 0);

    await tester.tap(find.text('Contact'));
    await tester.pump(); // kick off the animation
    await tester.pump(const Duration(milliseconds: 800)); // let it settle

    final after = tester.state<ScrollableState>(scrollable).position.pixels;
    expect(after, greaterThan(before));

    // Flush reveal Future.delayed timers triggered by sections scrolling past.
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Hero "View Work" button scrolls to the work section',
      (tester) async {
    await pumpApp(tester);
    final scrollable = find.byType(Scrollable).first;
    expect(tester.state<ScrollableState>(scrollable).position.pixels, 0);

    await tester.tap(find.text('View Work'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(tester.state<ScrollableState>(scrollable).position.pixels,
        greaterThan(0));
    await tester.pump(const Duration(seconds: 2)); // flush reveal timers
    expect(tester.takeException(), isNull);
  });

  testWidgets('Theme toggle flips brightness', (tester) async {
    final controller = await pumpApp(tester);
    expect(controller.isDark, isTrue);
    controller.toggle();
    await tester.pump();
    expect(controller.isDark, isFalse);
  });
}
