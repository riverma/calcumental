// The small-phone guard. Every screen and state, on the two 375pt phones (SE and 13 mini),
// at normal and very large text, in Mela and Raat, in English, Spanish and Hindi. Fails on
// any overflow (the framework reports it) and on any word split across two lines.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/core/problems.dart';
import 'package:mental_math/core/settings.dart';
import 'package:mental_math/l10n/strings.dart';
import 'package:mental_math/screens/menu.dart';
import 'package:mental_math/screens/play.dart';

import 'support.dart';

void main() {
  setUpAll(loadFonts);

  testWidgets('the guard itself catches a word split across lines', (tester) async {
    Widget box(String text) => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 80,
          child: Text(text, style: const TextStyle(fontFamily: 'Rozha One', fontSize: 28)),
        ),
      ),
    );
    await tester.pumpWidget(box('Featherstonehaugh'));
    expect(splitWords(tester), isNotEmpty);
    await tester.pumpWidget(box('one two three'));
    expect(splitWords(tester), isEmpty);
    await tester.pumpWidget(box('एक बार और कोशिश करें'));
    expect(splitWords(tester), isEmpty);
  });

  for (final lang in Lang.values) {
    for (final look in const [Look.mela, Look.raat]) {
      for (final size in const [Size(375, 667), Size(375, 812)]) {
        for (final scale in const [1.0, 2.0]) {
          final name = '${lang.name}, ${look.name}, ${size.width.toInt()}×${size.height.toInt()} at ${scale}x';

          testWidgets('$name: nothing overflows or splits a word', (tester) async {
            final s = S.of(lang);
            // Hard sums make the widest problems: 999 + 999 = ?
            final game = testGame(
              Settings(lang: lang, look: look, mode: Mode.add, level: Level.hard, count: 50),
            );
            game.toggleCustomize();
            await pumpApp(tester, game, size: size, textScale: scale);
            final seen = <String, List<String>>{};
            void check(String where) => seen[where] = splitWords(tester);

            check('menu');
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

            await tester.enterText(find.byType(EditableText), '${game.session.current.answer}');
            await tester.pump();
            await tapVisible(tester, find.bySemanticsLabel(s.check));
            check('right');
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

  testWidgets('a phone on its side uses the whole width', (tester) async {
    final game = testGame()..toggleCustomize();
    await pumpApp(tester, game, size: const Size(812, 375));
    expect(tester.getSize(find.byType(MenuScreen)).width, 812);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    expect(tester.getSize(find.byType(PlayScreen)).width, 812);
  });
}
