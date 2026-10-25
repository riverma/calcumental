// Khelo's components (src/components/*.css), as widgets.
//
// A control is a sticker: an ink outline and a hard, unblurred shadow. Pressing it pushes the
// sticker into its shadow. That squish is the only motion, it lasts a tenth of a second, it
// ends at rest, and reduced motion removes it. Every control is its own semantics node with
// a 44pt target, and a chosen state is carried by more than colour.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'icons.dart';
import 'theme.dart';
import 'tokens.dart';
import 'typography.dart';

List<BoxShadow> sticker(Color ink, double d) => [BoxShadow(color: ink, offset: Offset(d, d))];

// ---- press ---------------------------------------------------------------------------

/// What every control shares: the hit area, the semantics, keyboard activation, the focus
/// ring and the press state the control paints with.
class KhPressable extends StatefulWidget {
  const KhPressable({
    super.key,
    required this.onPressed,
    required this.builder,
    required this.label,
    this.selected,
    this.radius = Corner.pill,
    this.minHeight = Space.hit,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final Widget Function(BuildContext context, ({bool down, bool hover}) state) builder;
  final String label;

  /// For a choice: aria-pressed on the web, "selected" to VoiceOver.
  final bool? selected;
  final double radius;
  final double minHeight;
  final FocusNode? focusNode;

  @override
  State<KhPressable> createState() => _KhPressableState();
}

class _KhPressableState extends State<KhPressable> {
  bool _down = false, _hover = false, _focused = false;

  bool get _live => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final c = Kh.of(context).c;
    return Semantics(
      container: true,
      button: true,
      enabled: _live,
      selected: widget.selected,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _live,
        focusNode: widget.focusNode,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hover = v),
        actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => widget.onPressed?.call())},
        mouseCursor: _live ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _live ? (_) => setState(() => _down = true) : null,
          onTapCancel: _live ? () => setState(() => _down = false) : null,
          onTapUp: _live ? (_) => setState(() => _down = false) : null,
          onTap: widget.onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.minHeight, minWidth: Space.hit),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: DecoratedBox(
                // Focus: visible, always, and thick, because everything else here is thick.
                position: DecorationPosition.foreground,
                decoration: _focused
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.radius + 3),
                        border: Border.all(color: c.focusRing, width: 3, strokeAlign: 2),
                      )
                    : const BoxDecoration(),
                child: widget.builder(context, (down: _down, hover: _hover)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The squish: a sticker moves toward its shadow as the shadow shrinks.
class _Sticker extends StatelessWidget {
  const _Sticker({
    required this.state,
    required this.rest,
    required this.pressed,
    required this.decoration,
    required this.padding,
    required this.child,
    this.minHeight = 0,
    this.alignment = Alignment.center,
  });

  final ({bool down, bool hover}) state;
  final double rest;
  final double pressed;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double minHeight;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final c = Kh.of(context).c;
    final still = MediaQuery.of(context).disableAnimations;
    final shadow = decoration.boxShadow == null
        ? 0.0
        : state.down
        ? 1.0
        : state.hover
        ? rest + 2
        : rest;
    final shift = state.down ? pressed : (state.hover && decoration.boxShadow != null ? -1.0 : 0.0);
    return AnimatedContainer(
      duration: still ? Duration.zero : Motion.press,
      curve: Motion.squish,
      transform: Matrix4.translationValues(shift, shift, 0),
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: decoration.copyWith(boxShadow: decoration.boxShadow == null ? null : sticker(c.stickerInk, shadow)),
      // Sized to its content, not to the space it is offered.
      child: Align(alignment: alignment, widthFactor: 1, heightFactor: 1, child: child),
    );
  }
}

// ---- button --------------------------------------------------------------------------

enum KhButtonKind { primary, play, ghost }

enum KhButtonSize { sm, md, lg }

/// `.kh-btn`: a pill sticker. Primary is marigold, play is the second loud voice, ghost
/// sits on paper.
class KhButton extends StatelessWidget {
  const KhButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.kind = KhButtonKind.primary,
    this.size = KhButtonSize.md,
    this.icon,
    this.expand = false,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final KhButtonKind kind;
  final KhButtonSize size;
  final KhIcons? icon;
  final bool expand;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    final enabled = onPressed != null;
    final (bg, ink) = !enabled
        ? (c.sunk, c.secondary)
        : switch (kind) {
            KhButtonKind.primary => (c.primary, c.onPrimary),
            KhButtonKind.play => (c.play, c.onPlay),
            KhButtonKind.ghost => (c.elevated, c.body),
          };
    final (font, padding, rest, height) = switch (size) {
      KhButtonSize.sm => (15.0, const EdgeInsets.fromLTRB(14, 5, 14, 4), 2.0, 36.0),
      KhButtonSize.md => (17.0, const EdgeInsets.fromLTRB(22, 9, 22, 8), 4.0, Space.hit),
      KhButtonSize.lg => (20.0, const EdgeInsets.fromLTRB(30, 12, 30, 11), 6.0, 56.0),
    };
    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: kh.t.button(font).copyWith(color: ink),
    );
    return KhPressable(
      label: label,
      onPressed: onPressed,
      focusNode: focusNode,
      builder: (context, state) {
        final face = _Sticker(
          state: enabled ? state : (down: false, hover: false),
          rest: rest,
          pressed: 3,
          minHeight: height,
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Corner.pill),
            border: enabled ? Border.all(color: c.borderControl, width: Stroke.bold) : null,
            boxShadow: enabled ? const [] : null,
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[KhIcon(icon!, size: font * 1.3, ink: ink), const SizedBox(width: Space.s2)],
              Flexible(child: text),
            ],
          ),
        );
        // Disabled: the outline goes dashed and the shadow goes away.
        return enabled ? face : Dashed(color: c.borderControl, width: Stroke.bold, radius: Corner.pill, child: face);
      },
    );
  }
}

// ---- chip ----------------------------------------------------------------------------

/// `.kh-chip`: one choice among a few. Chosen, it takes the selected fill and a heavier
/// outline, so the state reads without colour.
class KhChip extends StatelessWidget {
  const KhChip(this.label, {super.key, required this.selected, required this.onPressed, this.semanticLabel});

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    return KhPressable(
      label: semanticLabel ?? label,
      selected: selected,
      onPressed: onPressed,
      builder: (context, state) => _Sticker(
        state: (down: state.down, hover: false),
        rest: selected ? 2 : 0,
        pressed: 1,
        minHeight: 36,
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 3),
        decoration: BoxDecoration(
          color: selected ? c.selectedFill : c.elevated,
          borderRadius: BorderRadius.circular(Corner.pill),
          border: Border.all(color: c.borderControl, width: selected ? Stroke.bold : Stroke.normal),
          boxShadow: selected ? const [] : null,
        ),
        child: Text(
          label,
          style: balooAt(
            700,
          ).copyWith(fontSize: 16, height: kh.t.devanagari ? 1.35 : 1.2, color: selected ? c.onSelected : c.body),
        ),
      ),
    );
  }
}

/// A labelled row of chips: a small caps heading and the choices under it.
class KhChoice<T> extends StatelessWidget {
  const KhChoice({
    super.key,
    required this.title,
    required this.values,
    required this.value,
    required this.labelOf,
    required this.onChanged,
  });

  final String title;
  final List<T> values;
  final T value;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Kh.of(context).t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title.toUpperCase(), style: t.caps)),
        const SizedBox(height: Space.s1),
        Wrap(
          spacing: Space.s2,
          children: [
            for (final v in values)
              KhChip(
                labelOf(v),
                selected: v == value,
                semanticLabel: '$title: ${labelOf(v)}',
                onPressed: () => onChanged(v),
              ),
          ],
        ),
      ],
    );
  }
}

// ---- tile ----------------------------------------------------------------------------

/// `.kh-tile`: one big choice, on a soft wash. Chosen, it takes the selected fill and a drawn
/// check.
class KhTile extends StatelessWidget {
  const KhTile({
    super.key,
    required this.glyph,
    required this.title,
    required this.wash,
    required this.selected,
    required this.onPressed,
    this.semanticLabel,
  });

  final Widget glyph;
  final String title;
  final Color wash;
  final bool selected;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    final ink = selected ? c.onSelected : c.body;
    return KhPressable(
      label: semanticLabel ?? title,
      selected: selected,
      radius: Corner.m,
      onPressed: onPressed,
      builder: (context, state) => _Sticker(
        state: state,
        rest: selected ? 4 : 2,
        pressed: 2,
        minHeight: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(Space.s3, Space.s2, Space.s4, Space.s2),
        decoration: BoxDecoration(
          color: selected ? c.selectedFill : wash,
          borderRadius: BorderRadius.circular(Corner.m),
          border: Border.all(color: c.borderControl, width: Stroke.bold),
          boxShadow: const [],
        ),
        // A full-width row, so the word always has the room it needs on a small phone.
        child: Row(
          children: [
            SizedBox.square(
              dimension: 40,
              child: Center(
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: ink),
                  child: glyph,
                ),
              ),
            ),
            const SizedBox(width: Space.s3),
            Expanded(
              child: Text(title, style: kh.t.sign(21).copyWith(color: ink)),
            ),
            const SizedBox(width: Space.s2),
            // A drawn check, so the choice reads without colour. Always laid out, so
            // choosing a tile never moves anything.
            Opacity(
              opacity: selected ? 1 : 0,
              child: KhIcon(KhIcons.check, size: 26, ink: ink),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- surfaces ------------------------------------------------------------------------

/// `.kh-card`: paper with an ink outline and a sticker shadow.
class KhCard extends StatelessWidget {
  const KhCard({super.key, required this.child, this.padding = const EdgeInsets.all(Space.s5), this.flat = false});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final c = Kh.of(context).c;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.elevated,
        borderRadius: BorderRadius.circular(Corner.l),
        border: Border.all(color: c.borderControl, width: flat ? Stroke.normal : Stroke.bold),
        boxShadow: flat ? null : sticker(c.stickerInk, 4),
      ),
      child: child,
    );
  }
}

enum NoticeKind { info, done, note }

/// `.kh-notice`: feedback that sits in the flow where the person caused it. Never a toast,
/// never a popup. Announced politely, never assertively.
class KhNotice extends StatelessWidget {
  const KhNotice({super.key, required this.kind, required this.text, this.icon, this.actions = const []});

  final NoticeKind kind;
  final String text;
  final KhIcons? icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    final body = Container(
      padding: const EdgeInsets.all(Space.s4),
      decoration: BoxDecoration(
        color: switch (kind) {
          NoticeKind.info => c.washMor,
          NoticeKind.done => c.doneWash,
          NoticeKind.note => c.washGenda,
        },
        borderRadius: BorderRadius.circular(Corner.m),
        border: switch (kind) {
          NoticeKind.note => null,
          NoticeKind.done => Border.all(color: c.done, width: Stroke.normal),
          NoticeKind.info => Border.all(color: c.borderControl, width: Stroke.normal),
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                KhIcon(icon!, size: kind == NoticeKind.done ? 34 : 30, ink: kind == NoticeKind.done ? c.done : null),
                const SizedBox(width: Space.s3),
              ],
              Expanded(
                child: Semantics(liveRegion: true, child: Text(text, style: kh.t.label.copyWith(fontSize: 19))),
              ),
            ],
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: Space.s3),
            Wrap(spacing: Space.s3, runSpacing: Space.s2, children: actions),
          ],
        ],
      ),
    );
    return kind == NoticeKind.note
        ? Dashed(color: c.borderControl, width: Stroke.normal, radius: Corner.m, child: body)
        : body;
  }
}

/// `.kh-steps`: progress through a finite set. One dot per problem, the total always in view.
class KhSteps extends StatelessWidget {
  const KhSteps({
    super.key,
    required this.total,
    required this.current,
    required this.label,
    required this.semanticLabel,
  });

  /// Zero-based; everything before it is done.
  final int current;
  final int total;
  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    Widget dot(int i) {
      final here = i == current;
      final size = here ? 15.2 * 1.2 : 15.2;
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: here ? c.selectedFill : (i < current ? c.done : null),
          border: Border.all(color: c.borderControl, width: Stroke.normal),
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Wrap(
        spacing: total > 20 ? 4 : Space.s2,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < total; i++) dot(i),
          Padding(
            padding: const EdgeInsets.only(left: Space.s2),
            child: Text(label, style: balooAt(700).copyWith(fontSize: 16, height: 1.2, color: c.secondary)),
          ),
        ],
      ),
    );
  }
}

/// `.kh-end`: the ending, offered as rest. A dashed frame on sunk paper.
class KhEnd extends StatelessWidget {
  const KhEnd({super.key, required this.mark, required this.title, required this.line});
  final KhIcons mark;
  final String title;
  final String line;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    return Dashed(
      color: c.borderControl,
      width: Stroke.bold,
      radius: Corner.l,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(Space.s5, Space.s6, Space.s5, Space.s6),
        decoration: BoxDecoration(color: c.sunk, borderRadius: BorderRadius.circular(Corner.l)),
        child: Column(
          children: [
            KhIcon(mark, size: 64),
            const SizedBox(height: Space.s3),
            Semantics(
              header: true,
              child: Text(title, textAlign: TextAlign.center, style: kh.t.h3),
            ),
            const SizedBox(height: Space.s2),
            Text(
              line,
              textAlign: TextAlign.center,
              style: kh.t.body.copyWith(color: c.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- input ---------------------------------------------------------------------------

/// `.kh-input`: a thick edge, a big target, a pressed-in shadow along the top and left.
/// Invalid, the edge goes dashed saffron. Something to look at, never an accusation: no red
/// and no shaking.
class KhInput extends StatelessWidget {
  const KhInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.editor,
    required this.label,
    required this.onSubmitted,
    this.invalid = false,
    this.locked = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  /// The text editor inside, so the keyboard can be asked for: iOS can hide it while the
  /// field keeps focus, and then focus alone will not bring it back.
  final GlobalKey<EditableTextState> editor;
  final String label;
  final VoidCallback onSubmitted;
  final bool invalid;

  /// The answer is in: the text stays as it is, but the field keeps focus and the keyboard,
  /// so Enter still works and the keyboard does not drop between problems.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final kh = Kh.of(context);
    final c = kh.c;
    final style = kh.t.answer;
    final field = ClipRRect(
      borderRadius: BorderRadius.circular(Corner.m),
      child: Container(
        color: c.sunk,
        padding: const EdgeInsets.only(left: 3, top: 3),
        child: Container(
          color: c.elevated,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 6),
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => controller.text.isEmpty
                    ? ExcludeSemantics(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: style.copyWith(color: c.secondary),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Semantics(
                label: label,
                child: EditableText(
                  key: editor,
                  // Taps go to the field around it, which raises the keyboard; the editor's own
                  // tap only moves the caret, and would otherwise swallow the touch.
                  rendererIgnoresPointer: true,
                  controller: controller,
                  focusNode: focusNode,
                  style: style,
                  cursorColor: c.body,
                  backgroundCursorColor: c.muted,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    if (locked) TextInputFormatter.withFunction((old, _) => old),
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  autocorrect: false,
                  enableSuggestions: false,
                  // Done would otherwise drop focus, and the keyboard with it.
                  onEditingComplete: () {},
                  // A tap elsewhere (Try again, Show me) must not take the keyboard away.
                  onTapOutside: (_) {},
                  onSubmitted: (_) => onSubmitted(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final edge = invalid
        ? Dashed(color: c.note, width: Stroke.bold, radius: Corner.m, child: field)
        : DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Corner.m),
              border: Border.all(color: c.borderControl, width: Stroke.bold),
            ),
            child: field,
          );
    return GestureDetector(onTap: () => showKeyboard(focusNode, editor), child: edge);
  }
}

/// Focus the field and raise the keyboard, even when the field already had focus.
void showKeyboard(FocusNode node, GlobalKey<EditableTextState> editor) {
  node.requestFocus();
  editor.currentState?.requestKeyboard();
}

// ---- dashes --------------------------------------------------------------------------

/// A dashed rounded outline, painted over its child: CSS `border-style: dashed`, which
/// Flutter's borders do not draw.
class Dashed extends StatelessWidget {
  const Dashed({super.key, required this.color, required this.width, required this.radius, required this.child});
  final Color color;
  final double width;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(foregroundPainter: _DashPainter(color, width, radius), child: child);
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color, this.width, this.radius);
  final Color color;
  final double width;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = (Offset.zero & size).deflate(width / 2);
    final path = Path()..addRRect(RRect.fromRectAndRadius(r, Radius.circular(radius.clamp(0, r.shortestSide / 2))));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final dash = width * 3, gap = width * 2;
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += dash + gap) {
        canvas.drawPath(m.extractPath(d, (d + dash).clamp(0, m.length)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color || old.width != width || old.radius != radius;
}
