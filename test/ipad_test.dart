// The iPad guard. Every screen, on an iPad mini and a 13-inch iPad Pro (both ways round), and
// in Split View or Slide Over at 320pt, the narrowest the app is ever given. Normal and very
// large text, Mela and Raat, English, Spanish and Hindi. Fails on any overflow (the framework
// reports it) and on any word split across two lines.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/core/problems.dart';
import 'package:mental_math/core/settings.dart';
import 'package:mental_math/design/theme.dart';
import 'package:mental_math/l10n/strings.dart';
import 'package:mental_math/screens/menu.dart';

import 'support.dart';

const _sizes = {
  'iPad mini': Size(744, 1133),
  'iPad Pro 13" portrait': Size(1032, 1376),
  'iPad Pro 13" landscape': Size(1376, 1032),
  'Split View': Size(320, 1133),
};

void main() {
  setUpAll(loadFonts);

  for (final lang in Lang.values) {
    for (final look in const [Look.mela, Look.raat]) {
      for (final MapEntry(key: device, value: size) in _sizes.entries) {
        for (final scale in const [1.0, 2.0]) {
          testWidgets('${lang.name}, ${look.name}, $device at ${scale}x: nothing overflows or splits a word', (
            tester,
          ) async {
            final s = S.of(lang);
            final game = testGame(
              Settings(lang: lang, look: look, mode: Mode.add, level: Level.hard, count: 50),
              1,
              true,
            );
            game.toggleCustomize();
            await pumpApp(tester, game, size: size, textScale: scale);
            final seen = <String, List<String>>{};
            void check(String where) => seen[where] = splitWords(tester);

            check('menu');
            await tapVisible(tester, find.bySemanticsLabel(s.about));
            check('about');
            await tapVisible(tester, find.bySemanticsLabel(s.back));

            await tapVisible(tester, find.bySemanticsLabel(s.letsPlay));
            check('asking');
            final p = game.session.current;
            await tester.enterText(find.byType(EditableText), '${p.answer + 9}');
            await tester.pump();
            await tapVisible(tester, find.bySemanticsLabel(s.check));
            check('not quite');
            await tapVisible(tester, find.bySemanticsLabel(s.showMe));
            check('shown');
            await tapVisible(tester, find.bySemanticsLabel(s.next));
            await tapVisible(tester, find.bySemanticsLabel(s.stop));
            check('ending');

            final split = {
              for (final e in seen.entries)
                if (e.value.isNotEmpty) e.key: e.value,
            };
            expect(split, isEmpty);
          });
        }
      }
    }
  }

  testWidgets('on a big iPad the page stays a readable width, centred', (tester) async {
    await pumpApp(tester, testGame(), size: const Size(1376, 1032));
    final menu = tester.getRect(find.byType(MenuScreen));
    expect(menu.width, maxWidth);
    expect(menu.center.dx, closeTo(1376 / 2, 1));
  });
}
