// The ending, offered as rest: it says the set is over, shows what you did, and lets you go.
// No tally, no rating, no "come back tomorrow".

import 'package:flutter/widgets.dart';

import '../app.dart';
import '../core/session.dart';
import '../design/components.dart';
import '../design/ground.dart';
import '../design/icons.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../design/typography.dart';

class EndingScreen extends StatelessWidget {
  const EndingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final session = game.session;
    final s = context.s;
    final kh = Kh.of(context);
    final c = kh.c;
    final done = session.done;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Kangura(),
            Padding(
              padding: EdgeInsets.fromLTRB(kh.gutter, Space.s5, kh.gutter, Space.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KhEnd(
                    mark: KhIcons.kamal,
                    title: session.stopped ? s.stoppedAfter(done.length, session.total) : s.allDone(session.total),
                    line: s.rest,
                  ),
                  const SizedBox(height: Space.s5),
                  Wrap(
                    spacing: Space.s4,
                    runSpacing: Space.s4,
                    children: [
                      KhButton(s.anotherSet, size: KhButtonSize.lg, onPressed: game.start),
                      KhButton(s.menu, kind: KhButtonKind.ghost, onPressed: game.menu),
                    ],
                  ),
                  if (done.isNotEmpty) ...[
                    const SizedBox(height: Space.s6),
                    KhCard(
                      padding: const EdgeInsets.fromLTRB(Space.s4, Space.s4, Space.s4, Space.s3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Semantics(header: true, child: Text(s.whatYouDid.toUpperCase(), style: kh.t.caps)),
                          const SizedBox(height: Space.s2),
                          for (final (i, a) in done.indexed) ...[
                            if (i > 0) Container(height: Stroke.normal, color: c.borderSoft),
                            _Row(a),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.a);
  final Attempted a;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final kh = Kh.of(context);
    final p = a.problem;
    final outcome = a.outcome!;
    // What you gave, when it was not simply the answer: earlier tries, or a close-enough one.
    final yours = [
      for (final g in a.answers)
        if (g != p.answer) g,
    ];
    final detail = [s.outcome(outcome), for (final g in yours) s.youSaid(g)].join(' · ');
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.s3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 28, child: outcome == Outcome.shown ? null : const KhIcon(KhIcons.check, size: 24)),
            const SizedBox(width: Space.s2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${p.text} = ${p.answer}',
                    style: balooAt(800).copyWith(fontSize: 19, height: 1.3, color: kh.c.body),
                  ),
                  Text(detail, style: kh.t.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
