// The whole game, as a person plays it: the menu, a wrong answer, another go, a shown answer,
// and the ending. Nothing advances unless a button is pressed.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/core/problems.dart';
import 'package:mental_math/core/session.dart';
import 'package:mental_math/core/settings.dart';
import 'package:mental_math/game.dart';
import 'package:mental_math/screens/about.dart';
import 'package:mental_math/screens/ending.dart';
import 'package:mental_math/screens/menu.dart';
import 'package:mental_math/screens/play.dart';

import 'support.dart';

Future<void> type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText), text);
  await tester.pump();
}

void main() {
  setUpAll(loadFonts);

  testWidgets('a set from Let\'s play to the ending', (tester) async {
    final game = testGame(const Settings(count: 5, mode: Mode.add));
    await pumpApp(tester, game);
    expect(find.byType(MenuScreen), findsOneWidget);

    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    expect(find.byType(PlayScreen), findsOneWidget);
    // Let's play is the saved choices: here, five sums.
    expect(game.session.total, 5);
    expect(game.session.current.op, Op.add);
    expect(find.text('1 of 5'), findsOneWidget);

    // Not quite: the field stays, a kind word, and two ways on.
    final p = game.session.current;
    await type(tester, '${p.answer + 3}');
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    expect(find.text('Not quite. Have another go.'), findsOneWidget);
    expect(find.bySemanticsLabel('Next'), findsNothing);

    await tapVisible(tester, find.bySemanticsLabel('Try again'));
    await type(tester, '${p.answer}');
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    expect(find.text('That’s it! ${p.text} = ${p.answer}'), findsOneWidget);

    // It waits. Time passing changes nothing.
    await tester.pump(const Duration(seconds: 30));
    expect(game.session.index, 0);
    await tapVisible(tester, find.bySemanticsLabel('Next'));
    expect(find.text('2 of 5'), findsOneWidget);

    // Show me.
    final q = game.session.current;
    await type(tester, '${q.answer + 50}');
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    await tapVisible(tester, find.bySemanticsLabel('Show me'));
    expect(find.text('Here it is: ${q.text} = ${q.answer}'), findsOneWidget);

    // The rest, right first time, ending on Finish.
    for (var i = 2; i < 5; i++) {
      await tapVisible(tester, find.bySemanticsLabel('Next'));
      await type(tester, '${game.session.current.answer}');
      await tapVisible(tester, find.bySemanticsLabel('Check'));
    }
    expect(find.bySemanticsLabel('Finish'), findsOneWidget);
    await tapVisible(tester, find.bySemanticsLabel('Finish'));

    expect(find.byType(EndingScreen), findsOneWidget);
    expect(find.text('That’s all 5. Nice work.'), findsOneWidget);
    expect(find.text('${p.text} = ${p.answer}'), findsOneWidget);
    expect(find.text('after another go · you said ${p.answer + 3}'), findsOneWidget);
    expect(find.text('shown · you said ${q.answer + 50}'), findsOneWidget);
    // Nothing on the ending counts or rates.
    expect(find.textContaining('%'), findsNothing);

    await tapVisible(tester, find.bySemanticsLabel('Another set'));
    expect(game.session.phase, Phase.asking);
    expect(game.session.index, 0);
  });

  testWidgets('after a not quite, typing starts a fresh answer without Try again', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    final wrong = '${game.session.current.answer + 3}';
    await type(tester, wrong);
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    expect(game.session.phase, Phase.notQuite);

    // One more digit on the end of the old answer: that digit alone is the new answer.
    await type(tester, '${wrong}7');
    expect(game.session.phase, Phase.asking);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Not quite. Have another go.'), findsNothing);
    expect(find.bySemanticsLabel('Check'), findsOneWidget);
  });

  testWidgets('after a not quite, backspace trims the old answer without Try again', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    final wrong = '${game.session.current.answer + 30}';
    await type(tester, wrong);
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    expect(game.session.phase, Phase.notQuite);

    await type(tester, wrong.substring(0, wrong.length - 1));
    expect(game.session.phase, Phase.asking);
    expect(find.text(wrong.substring(0, wrong.length - 1)), findsOneWidget);
  });

  testWidgets('Enter does what the visible button does', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    await type(tester, '${game.session.current.answer}');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(game.session.phase, Phase.settled);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(game.session.index, 1);
    expect(game.session.phase, Phase.asking);
  });

  testWidgets('the keyboard comes back after Try again, and on a tap of the field', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    expect(tester.testTextInput.isVisible, isTrue);

    await type(tester, '${game.session.current.answer + 1}');
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    // The keyboard can go away while the field keeps focus; focus alone will not bring it back.
    tester.testTextInput.hide();
    expect(tester.testTextInput.isVisible, isFalse);

    await tapVisible(tester, find.bySemanticsLabel('Try again'));
    expect(tester.testTextInput.isVisible, isTrue);

    tester.testTextInput.hide();
    await tester.tap(find.byType(EditableText));
    await settle(tester);
    expect(tester.testTextInput.isVisible, isTrue);
  });

  testWidgets('stopping part-way shows what was done', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    final p = game.session.current;
    await type(tester, '${p.answer}');
    await tapVisible(tester, find.bySemanticsLabel('Check'));
    await tapVisible(tester, find.bySemanticsLabel('Next'));
    await tapVisible(tester, find.bySemanticsLabel('Stop'));
    expect(find.text('You stopped after 1 of 10.'), findsOneWidget);
    expect(find.text('${p.text} = ${p.answer}'), findsOneWidget);
    await tapVisible(tester, find.bySemanticsLabel('Back to the menu'));
    expect(find.byType(MenuScreen), findsOneWidget);
  });

  testWidgets('Apply keeps the choices for Let\'s play and next time, and closes Customize', (tester) async {
    final game = testGame();
    final store = game.store as MemorySettings;
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Customize'));
    await tapVisible(tester, find.bySemanticsLabel('What to practice: Divide'));
    await tapVisible(tester, find.bySemanticsLabel('Level: Hard'));
    await tapVisible(tester, find.bySemanticsLabel('How close: Close enough'));
    await tapVisible(tester, find.bySemanticsLabel('How many: 20'));
    // Nothing is kept until Apply.
    expect(store.saved.mode, Mode.multiply);

    await tapVisible(tester, find.bySemanticsLabel('Apply'));
    expect(find.bySemanticsLabel('Apply'), findsNothing);
    expect(
      (store.saved.mode, store.saved.level, store.saved.scoring, store.saved.count),
      (Mode.divide, Level.hard, Scoring.rough, 20),
    );

    // Language and look are not part of Customize; they switch in place, at once.
    await tapVisible(tester, find.bySemanticsLabel('Look: Raat'));
    await tapVisible(tester, find.bySemanticsLabel('Language: हिन्दी'));
    expect((store.saved.look, store.saved.lang), (Look.raat, Lang.hi));
    expect(find.text('कैल्कुमेंटल'), findsOneWidget);

    await tapVisible(tester, find.bySemanticsLabel('चलो खेलें'));
    expect(game.session.total, 20);
    expect(game.session.current.op, Op.divide);
    expect(find.text('20 में से 1'), findsOneWidget);
  });

  testWidgets('closing Customize without Apply keeps the saved choices', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('Customize'));
    await tapVisible(tester, find.bySemanticsLabel('What to practice: Plus'));
    await tapVisible(tester, find.bySemanticsLabel('Customize'));
    expect(find.bySemanticsLabel('Apply'), findsNothing);
    expect((game.store as MemorySettings).saved.mode, Mode.multiply);

    // Opening it again shows what is saved, not the choice left behind.
    await tapVisible(tester, find.bySemanticsLabel('Customize'));
    expect(game.draft!.mode, Mode.multiply);
    await tapVisible(tester, find.bySemanticsLabel('Let’s play'));
    expect(game.session.current.op, Op.multiply);
  });

  testWidgets('About tells the story and shows the version; no Donate in the iOS app', (tester) async {
    final game = testGame();
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('About'));
    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.textContaining('young girl in Mexico'), findsOneWidget);
    expect(find.text('Version: $appVersion'), findsOneWidget);
    expect(find.bySemanticsLabel('Donate'), findsNothing);
    expect(find.bySemanticsLabel('View privacy policy'), findsOneWidget);
    await tapVisible(tester, find.bySemanticsLabel('Back'));
    expect(find.byType(MenuScreen), findsOneWidget);
  });

  testWidgets('the web build offers Donate on About', (tester) async {
    final game = testGame(const Settings(), 1, true);
    await pumpApp(tester, game);
    await tapVisible(tester, find.bySemanticsLabel('About'));
    expect(find.bySemanticsLabel('Donate'), findsOneWidget);
    expect(find.bySemanticsLabel('View privacy policy'), findsOneWidget);
    await tapVisible(tester, find.bySemanticsLabel('Back'));
    expect(find.byType(MenuScreen), findsOneWidget);
  });
}
