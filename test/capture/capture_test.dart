// Screenshots for visual review, rendered with the real fonts and icons: every screen and
// state, in Mela and Raat, in each language. Skipped unless asked for:
//
//   CAPTURE=1 flutter test test/capture        (writes build/shots/*.png)

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/app.dart';
import 'package:mental_math/core/problems.dart';
import 'package:mental_math/core/settings.dart';
import 'package:mental_math/l10n/strings.dart';

import '../support.dart';

void main() {
  final on = Platform.environment['CAPTURE'] == '1';
  setUpAll(loadFonts);

  for (final lang in Lang.values) {
    for (final look in const [Look.mela, Look.raat]) {
      testWidgets('${lang.name} ${look.name}', (tester) async {
        final s = S.of(lang);
        final game = testGame(Settings(lang: lang, look: look, count: 10), 3);
        game.toggleCustomize();
        await pumpApp(tester, game, size: const Size(390, 844));

        Future<void> shot(String name) async {
          // Icons decode off the frame; give a new colour set time to land before the picture.
          await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
          await settle(tester);
          final image = await captureImage(find.byType(MathApp).evaluate().single);
          final bytes = (await tester.runAsync(() => image.toByteData(format: ui.ImageByteFormat.png)))!;
          final f = File('build/shots/${lang.name}-${look.name}-$name.png')..createSync(recursive: true);
          f.writeAsBytesSync(bytes.buffer.asUint8List());
        }

        await shot('1-menu');
        final scroller = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(find.bySemanticsLabel(s.about), 300, scrollable: scroller);
        await shot('1-menu-footer');
        await tapVisible(tester, find.bySemanticsLabel(s.about));
        await shot('6-about');
        await tapVisible(tester, find.bySemanticsLabel(s.back));
        await tapVisible(tester, find.bySemanticsLabel(s.letsPlay));
        await tester.enterText(find.byType(EditableText), '5');
        await tester.pump();
        await shot('2-asking');

        final p = game.session.current;
        await tester.enterText(find.byType(EditableText), '${p.answer + 2}');
        await tester.pump();
        await tapVisible(tester, find.bySemanticsLabel(s.check));
        await shot('3-not-quite');

        await tapVisible(tester, find.bySemanticsLabel(s.tryAgain));
        await tester.enterText(find.byType(EditableText), '${p.answer}');
        await tester.pump();
        await tapVisible(tester, find.bySemanticsLabel(s.check));
        await shot('4-right');
        await tapVisible(tester, find.bySemanticsLabel(s.next));

        await tester.enterText(find.byType(EditableText), '1');
        await tester.pump();
        await tapVisible(tester, find.bySemanticsLabel(s.check));
        await tapVisible(tester, find.bySemanticsLabel(s.showMe));
        await tapVisible(tester, find.bySemanticsLabel(s.next));
        for (var i = 2; i < 10; i++) {
          await tester.enterText(find.byType(EditableText), '${game.session.current.answer}');
          await tester.pump();
          await tapVisible(tester, find.bySemanticsLabel(s.check));
          await tapVisible(tester, find.bySemanticsLabel(i == 9 ? s.finish : s.next));
        }
        await shot('5-ending');
        expect(game.session.current.op, Op.multiply);
      }, skip: !on);
    }
  }

  // iPad Pro 13", in English: the start of the iPad App Store screenshots.
  for (final look in const [Look.mela, Look.raat]) {
    testWidgets('ipad ${look.name}', (tester) async {
      final s = S.of(Lang.en);
      final game = testGame(Settings(look: look, count: 10), 3);
      await pumpApp(tester, game, size: const Size(1032, 1376));

      Future<void> shot(String name) async {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
        await settle(tester);
        final image = await captureImage(find.byType(MathApp).evaluate().single);
        final bytes = (await tester.runAsync(() => image.toByteData(format: ui.ImageByteFormat.png)))!;
        final f = File('build/shots/ipad-${look.name}-$name.png')..createSync(recursive: true);
        f.writeAsBytesSync(bytes.buffer.asUint8List());
      }

      await shot('1-menu');
      await tapVisible(tester, find.bySemanticsLabel(s.about));
      await shot('2-about');
      await tapVisible(tester, find.bySemanticsLabel(s.back));
      await tapVisible(tester, find.bySemanticsLabel(s.letsPlay));
      await tester.enterText(find.byType(EditableText), '42');
      await tester.pump();
      await shot('3-asking');
    }, skip: !on);
  }
}
