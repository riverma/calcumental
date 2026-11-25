// The menu: one block-lettered title, one big "Let's play", and your own choices folded away
// until you ask for them. Nothing here appears on its own or asks you to come back.

import 'package:flutter/widgets.dart';

import '../app.dart';
import '../core/problems.dart';
import '../core/settings.dart';
import '../design/components.dart';
import '../design/ground.dart';
import '../design/icons.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../l10n/strings.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final st = game.settings;
    final s = context.s;
    final kh = Kh.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Kangura(),
            Padding(
              padding: EdgeInsets.fromLTRB(kh.gutter, Space.s6, kh.gutter, Space.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    // One word, so it shrinks to fit instead of breaking in the middle.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(s.appTitle, style: kh.t.poster(), maxLines: 1),
                    ),
                  ),
                  const SizedBox(height: Space.s4),
                  Text(s.lead, style: kh.t.lead),
                  const SizedBox(height: Space.s5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: KhButton(s.letsPlay, size: KhButtonSize.lg, icon: KhIcons.lattu, onPressed: game.start),
                  ),
                  const SizedBox(height: Space.s4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: KhButton(
                      s.chooseOwn,
                      kind: KhButtonKind.ghost,
                      onPressed: game.toggleCustomize,
                    ),
                  ),
                  if (game.draft != null) ...[const SizedBox(height: Space.s5), const _Customize()],
                  const SizedBox(height: Space.s7),
                  _Footer(settings: st),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Customize extends StatelessWidget {
  const _Customize();

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final st = game.draft!;
    final s = context.s;
    final kh = Kh.of(context);
    final c = kh.c;
    final washes = {
      Mode.multiply: c.washGenda,
      Mode.add: c.washRani,
      Mode.subtract: c.washFirozi,
      Mode.divide: c.washTota,
      Mode.mixed: c.washMor,
    };

    return KhCard(
      padding: const EdgeInsets.fromLTRB(Space.s4, Space.s4, Space.s4, Space.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(s.practise.toUpperCase(), style: kh.t.caps)),
          const SizedBox(height: Space.s2),
          for (final m in Mode.values) ...[
            if (m != Mode.values.first) const SizedBox(height: Space.s3),
            KhTile(
              glyph: m == Mode.mixed
                  ? const KhIcon(KhIcons.mixed, size: 36)
                  : Text(
                      opSymbol[Op.values.byName(m.name)]!,
                      // The tile's own ink, which changes when it is chosen.
                      style: kh.t.sign(32).copyWith(height: 1.05, color: st.mode == m ? c.onSelected : c.body),
                    ),
              title: s.mode(m),
              wash: washes[m]!,
              selected: st.mode == m,
              semanticLabel: '${s.practise}: ${s.mode(m)}',
              onPressed: () => game.edit((x) => x.copyWith(mode: m)),
            ),
          ],
          const SizedBox(height: Space.s5),
          KhChoice<Level>(
            title: s.level,
            values: Level.values,
            value: st.level,
            labelOf: s.levelName,
            onChanged: (v) => game.edit((x) => x.copyWith(level: v)),
          ),
          const SizedBox(height: Space.s4),
          KhChoice<Scoring>(
            title: s.howClose,
            values: Scoring.values,
            value: st.scoring,
            labelOf: s.scoring,
            onChanged: (v) => game.edit((x) => x.copyWith(scoring: v)),
          ),
          const SizedBox(height: Space.s4),
          KhChoice<int>(
            title: s.howMany,
            values: lengths,
            value: st.count,
            labelOf: (n) => '$n',
            onChanged: (v) => game.edit((x) => x.copyWith(count: v)),
          ),
          const SizedBox(height: Space.s5),
          Align(
            alignment: Alignment.centerLeft,
            child: KhButton(s.apply, kind: KhButtonKind.play, onPressed: game.apply),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.settings});
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KhChoice<Lang>(
          title: s.language,
          values: Lang.values,
          value: settings.lang,
          labelOf: (l) => S.langLabel[l]!,
          onChanged: (v) => game.update((x) => x.copyWith(lang: v)),
        ),
        const SizedBox(height: Space.s4),
        KhChoice<Look>(
          title: s.look,
          values: Look.values,
          value: settings.look,
          labelOf: s.lookName,
          onChanged: (v) => game.update((x) => x.copyWith(look: v)),
        ),
        const SizedBox(height: Space.s5),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: KhButton(s.about, size: KhButtonSize.sm, kind: KhButtonKind.ghost, onPressed: game.about),
        ),
      ],
    );
  }
}
