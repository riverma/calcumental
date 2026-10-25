// Play: one problem at a time, the whole set's length always in view, and nothing that moves
// on without you. A wrong answer is "not quite": try again, or ask to see it.
//
// Focus goes to the answer field only because of something you pressed (Let's play, Next,
// Try again), never on its own. Enter does whatever the visible button does.

import 'package:flutter/widgets.dart';

import '../app.dart';
import '../core/problems.dart';
import '../core/session.dart';
import '../design/components.dart';
import '../design/icons.dart';
import '../design/theme.dart';
import '../design/tokens.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final _answer = TextEditingController();
  final _field = FocusNode(debugLabel: 'answer');
  final _editor = GlobalKey<EditableTextState>();
  int? _shownIndex;

  @override
  void initState() {
    super.initState();
    // The person just pressed Let's play or Start: the field is where they meant to go.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showKeyboard(_field, _editor);
    });
  }

  @override
  void dispose() {
    _answer.dispose();
    _field.dispose();
    super.dispose();
  }

  void _primary() {
    final game = Scope.of(context);
    final session = game.session;
    switch (session.phase) {
      case Phase.asking:
        final given = parseAnswer(_answer.text);
        if (given != null) game.answer(given);
      case Phase.notQuite:
        _tryAgain();
      case Phase.settled:
        game.next();
        _answer.clear();
        showKeyboard(_field, _editor);
      case Phase.ended:
        break;
    }
  }

  void _tryAgain() {
    Scope.of(context).tryAgain();
    _answer.clear();
    showKeyboard(_field, _editor);
  }

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final session = game.session;
    final s = context.s;
    final kh = Kh.of(context);
    final p = session.current;
    final phase = session.phase;
    final last = session.index + 1 == session.total;

    // A new problem starts with an empty field.
    if (_shownIndex != session.index) {
      _shownIndex = session.index;
      if (_answer.text.isNotEmpty) _answer.clear();
    }

    final notice = switch (phase) {
      Phase.notQuite => KhNotice(
        kind: NoticeKind.note,
        text: s.notQuite,
        actions: [
          KhButton(s.tryAgain, size: KhButtonSize.sm, onPressed: _tryAgain),
          KhButton(s.showMe, size: KhButtonSize.sm, kind: KhButtonKind.ghost, onPressed: game.show),
        ],
      ),
      Phase.settled => switch (session.here.outcome) {
        Outcome.shown => KhNotice(kind: NoticeKind.info, text: s.shown(p)),
        _ =>
          session.here.accepted == p.answer
              ? KhNotice(kind: NoticeKind.done, icon: KhIcons.check, text: s.right(p))
              : KhNotice(kind: NoticeKind.done, icon: KhIcons.check, text: s.closeEnough(p)),
      },
      _ => null,
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(kh.gutter, Space.s3, kh.gutter, Space.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: KhButton(
                s.stop,
                size: KhButtonSize.sm,
                kind: KhButtonKind.ghost,
                icon: KhIcons.cross,
                onPressed: game.stop,
              ),
            ),
            const SizedBox(height: Space.s4),
            KhSteps(
              total: session.total,
              current: session.index,
              label: s.steps(session.index + 1, session.total),
              semanticLabel: s.problemOf(session.index + 1, session.total),
            ),
            const SizedBox(height: Space.s6),
            // The view's one block-lettered title, on one line so the field and its button
            // stay above the keyboard. It shrinks rather than wrap.
            Semantics(
              header: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text('${p.text} = ?', maxLines: 1, style: kh.t.poster()),
              ),
            ),
            const SizedBox(height: Space.s5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: KhInput(
                    controller: _answer,
                    focusNode: _field,
                    editor: _editor,
                    label: s.yourAnswer,
                    invalid: phase == Phase.notQuite,
                    locked: phase != Phase.asking,
                    onSubmitted: _primary,
                  ),
                ),
                if (phase == Phase.asking) ...[
                  const SizedBox(width: Space.s3),
                  ListenableBuilder(
                    listenable: _answer,
                    builder: (context, _) =>
                        KhButton(s.check, onPressed: parseAnswer(_answer.text) == null ? null : _primary),
                  ),
                ],
              ],
            ),
            if (notice != null) ...[const SizedBox(height: Space.s4), notice],
            if (phase == Phase.settled) ...[
              const SizedBox(height: Space.s5),
              Align(
                alignment: Alignment.centerLeft,
                child: KhButton(last ? s.finish : s.next, size: KhButtonSize.lg, onPressed: _primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
