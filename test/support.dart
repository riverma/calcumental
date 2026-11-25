// Shared test setup: Khelo's real fonts (so widths are true to the device) and an app booted
// with settings held in memory.

import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/app.dart';
import 'package:mental_math/core/settings.dart';
import 'package:mental_math/game.dart';

Future<void> loadFonts() async {
  for (final (name, file) in [
    ('Rozha One', 'RozhaOne-Regular.ttf'),
    ('Yatra One', 'YatraOne-Regular.ttf'),
    ('Baloo 2', 'Baloo2-VariableFont.ttf'),
  ]) {
    final loader = FontLoader(name)
      ..addFont(Future.value(ByteData.sublistView(File('assets/fonts/$file').readAsBytesSync())));
    await loader.load();
  }
}

Game testGame([Settings settings = const Settings(), int seed = 1, bool offersDonate = false]) =>
    Game(store: MemorySettings(settings), settings: settings, random: Random(seed), offersDonate: offersDonate);

Future<void> pumpApp(
  WidgetTester tester,
  Game game, {
  Size size = const Size(375, 812),
  double textScale = 1,
  bool dark = false,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.platformBrightnessTestValue = dark ? Brightness.dark : Brightness.light;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await tester.pumpWidget(MathApp(game: game));
  await settle(tester);
}

/// Icons load their SVG from the asset bundle and decode it off the frame, so let real time
/// pass for them before settling.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
  await tester.pumpAndSettle();
}

/// Scroll something into view, then tap it, as a person would.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  if (finder.hitTestable().evaluate().isEmpty) {
    await tester.dragUntilVisible(finder, find.byType(SingleChildScrollView).first, const Offset(0, -120));
    await tester.pumpAndSettle();
  }
  await tester.tap(finder);
  await settle(tester);
}

/// Every paragraph on screen whose lines break inside a word. A line may start after a space,
/// a hyphen or a dash; anything else means a word was split. Lines come from the paragraph's
/// own boundaries, so Devanagari's joined letters are judged as the shaper laid them out.
List<String> splitWords(WidgetTester tester) {
  final problems = <String>[];
  for (final element in find.byType(RichText).evaluate()) {
    final render = element.renderObject;
    if (render is! RenderParagraph || !render.hasSize || !render.attached) continue;
    // An inline widget is one placeholder character, as the painter counts.
    final text = render.text.toPlainText(includeSemanticsLabels: false);
    if (text.length < 2) continue;
    // The same text, laid out the same way, so its line boundaries can be asked for.
    final painter = TextPainter(
      text: render.text,
      textAlign: render.textAlign,
      textDirection: render.textDirection,
      textScaler: render.textScaler,
      maxLines: render.maxLines,
      locale: render.locale,
      strutStyle: render.strutStyle,
      textWidthBasis: render.textWidthBasis,
    );
    final inline = <PlaceholderDimensions>[];
    render.visitChildren((child) {
      inline.add(PlaceholderDimensions(size: (child as RenderBox).size, alignment: PlaceholderAlignment.middle));
    });
    painter
      ..setPlaceholderDimensions(inline)
      ..layout(maxWidth: render.size.width);
    final starts = <int>{for (var i = 0; i < text.length; i++) painter.getLineBoundary(TextPosition(offset: i)).start};
    painter.dispose();
    for (final start in starts) {
      if (start <= 0 || start >= text.length) continue;
      final ok = RegExp(r'[\s\-–—/·।]').hasMatch(text[start - 1]) || RegExp(r'\s').hasMatch(text[start]);
      if (!ok) problems.add('"${text.replaceAll('\n', ' ')}" breaks inside a word at ${text.substring(0, start)}|');
    }
  }
  return problems;
}
