import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/core/problems.dart';
import 'package:mental_math/core/session.dart';
import 'package:mental_math/core/settings.dart';

void main() {
  group('problems keep the web app\'s ranges', () {
    final gen = Problems(Random(7));
    bool between(int v, int lo, int hi) => v >= lo && v <= hi;

    for (final level in Level.values) {
      test('$level', () {
        for (var i = 0; i < 2000; i++) {
          for (final mode in Mode.values) {
            final p = gen.make(mode, level);
            if (mode != Mode.mixed) expect(p.op.name, mode.name);
            switch ((p.op, level)) {
              case (Op.multiply, Level.easy):
                expect(between(p.a, 2, 9) && between(p.b, 2, 9), isTrue);
              case (Op.multiply, Level.medium):
                final small = min(p.a, p.b), big = max(p.a, p.b);
                expect(between(small, 2, 9) && between(big, 10, 99), isTrue);
              case (Op.multiply, Level.hard):
                expect(between(p.a, 10, 99) && between(p.b, 10, 99), isTrue);
              case (Op.add, Level.easy):
                expect(between(p.a, 2, 20) && between(p.b, 2, 20), isTrue);
              case (Op.add, Level.medium):
                expect(between(p.a, 10, 99) && between(p.b, 10, 99), isTrue);
              case (Op.add, Level.hard):
                expect(between(p.a, 100, 999) && between(p.b, 100, 999), isTrue);
              case (Op.subtract, _):
                final (lo, hi) = switch (level) {
                  Level.easy => (5, 30),
                  Level.medium => (30, 200),
                  Level.hard => (200, 999),
                };
                expect(between(p.a, lo, hi), isTrue);
                expect(between(p.b, 1, p.a), isTrue);
                expect(p.answer, greaterThanOrEqualTo(0), reason: 'subtraction never goes negative');
              case (Op.divide, _):
                expect(p.a % p.b, 0, reason: 'division always comes out whole');
                expect(p.answer * p.b, p.a);
            }
          }
        }
      });
    }

    test('mixed uses every operation', () {
      final ops = {for (var i = 0; i < 200; i++) gen.make(Mode.mixed, Level.easy).op};
      expect(ops, Op.values.toSet());
    });

    test('a set has exactly the length asked for', () {
      for (final n in lengths) {
        expect(gen.set(Mode.add, Level.easy, n), hasLength(n));
      }
    });
  });

  group('close enough', () {
    test('exact means exact', () {
      expect(isCorrect(56, 56, Scoring.exact), isTrue);
      expect(isCorrect(56, 57, Scoring.exact), isFalse);
    });
    test('within 5%, never less than 1', () {
      expect(isCorrect(10, 11, Scoring.rough), isTrue);
      expect(isCorrect(10, 12, Scoring.rough), isFalse);
      expect(isCorrect(1000, 1050, Scoring.rough), isTrue);
      expect(isCorrect(1000, 1051, Scoring.rough), isFalse);
      expect(isCorrect(0, 1, Scoring.rough), isTrue);
    });
  });

  test('an answer is digits, with a minus only in front', () {
    expect(parseAnswer(' 42 '), 42);
    expect(parseAnswer('-3'), -3);
    expect(parseAnswer(''), isNull);
    expect(parseAnswer('-'), isNull);
    expect(parseAnswer('4-2'), isNull);
    expect(parseAnswer('4.2'), isNull);
  });

  group('a session', () {
    const p1 = Problem(7, 8, Op.multiply), p2 = Problem(9, 3, Op.divide), p3 = Problem(5, 4, Op.add);
    Session fresh() => Session([p1, p2, p3], Scoring.exact);

    test('runs to its end and no further', () {
      final s = fresh();
      for (final p in [p1, p2, p3]) {
        expect(s.current, p);
        expect(s.answer(p.answer), isTrue);
        expect(s.phase, Phase.settled);
        s.next();
      }
      expect(s.phase, Phase.ended);
      expect(s.stopped, isFalse);
      expect(s.done.map((a) => a.outcome), everyElement(Outcome.first));
    });

    test('not quite, then try again', () {
      final s = fresh();
      expect(s.answer(54), isFalse);
      expect(s.phase, Phase.notQuite);
      s.tryAgain();
      expect(s.phase, Phase.asking);
      expect(s.answer(56), isTrue);
      expect(s.here.outcome, Outcome.retried);
      expect(s.here.answers, [54, 56]);
    });

    test('show me settles it without an answer', () {
      final s = fresh();
      s.answer(1);
      s.show();
      expect(s.phase, Phase.settled);
      expect(s.here.outcome, Outcome.shown);
      expect(s.here.accepted, isNull);
    });

    test('stopping keeps what was done and drops the one in hand', () {
      final s = fresh();
      s.answer(56);
      s.next();
      s.answer(2);
      s.stop();
      expect(s.phase, Phase.ended);
      expect(s.stopped, isTrue);
      expect(s.done.map((a) => a.problem), [p1]);
    });
  });

  group('settings', () {
    test('round-trip', () {
      const s = Settings(
        lang: Lang.hi,
        look: Look.raat,
        mode: Mode.mixed,
        level: Level.hard,
        scoring: Scoring.rough,
        count: 50,
      );
      final back = Settings.fromJson(s.toJson());
      expect(back.toJson(), s.toJson());
    });
    test('anything unknown falls back to the default', () {
      final s = Settings.fromJson({'lang': 'fr', 'count': 7, 'mode': 3});
      expect(s.toJson(), const Settings().toJson());
    });
  });
}
