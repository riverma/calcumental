// Khelo's drawn icons (assets/icons/, copied unchanged from khelo-design src/icons/), plus
// one drawn here in the same hand (48-unit grid, 2.5 outline, round joins, flat fills):
// mixed.svg, two passing arrows.
//
// On the web, icons.css paints them: the outline is currentColor and each `kh-f-*` class
// takes the aesthetic's fill. Flutter's SVG renderer has no stylesheet, so the same two
// substitutions happen on the text before it is drawn. Icons are decorative: the meaning is
// always in the words beside them.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'theme.dart';
import 'tokens.dart';

enum KhIcons { check, cross, lattu, kamal, genda, rangoli, mixed }

/// Every icon is drawn from a picture that is decoded once and then kept, so a screen that
/// shows an icon shows it on its first frame. Decoding on every mount left the spot empty for a
/// frame or two, which read as flicker when moving between screens.
final _texts = <KhIcons, String>{};
final _pictures = <String, PictureInfo>{};
final _loading = <String, Future<PictureInfo>>{};

String _hex(Color c) => '#${(c.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}';

Future<String> _text(KhIcons icon) async =>
    _texts[icon] ??= await rootBundle.loadString('assets/icons/${icon.name}.svg');

String _painted(String svg, KhColors c, Color? ink) {
  var out = svg.replaceAll('currentColor', _hex(ink ?? c.body));
  c.icon.forEach((name, fill) => out = out.replaceAll('class="kh-f-$name"', 'fill="${_hex(fill)}"'));
  return out;
}

Future<PictureInfo> _load(String painted) => _loading[painted] ??= vg
    .loadPicture(SvgStringLoader(painted), null)
    .then((info) => _pictures[painted] = info);

/// Decodes every icon in both looks, in the inks the app uses, before the first screen shows.
Future<void> warmIcons() async {
  for (final icon in KhIcons.values) {
    await _text(icon);
  }
  final jobs = <Future<void>>[];
  for (final c in [mela, raat]) {
    for (final ink in {c.body, c.onSelected, c.onPrimary, c.onPlay}) {
      for (final icon in KhIcons.values) {
        jobs.add(_load(_painted(_texts[icon]!, c, ink)));
      }
    }
  }
  await Future.wait(jobs);
}

class KhIcon extends StatefulWidget {
  const KhIcon(this.icon, {super.key, this.size = 27, this.ink});

  final KhIcons icon;
  final double size;

  /// The outline. Defaults to the body ink, as currentColor would.
  final Color? ink;

  @override
  State<KhIcon> createState() => _KhIconState();
}

class _KhIconState extends State<KhIcon> {
  void _again() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = Kh.of(context).c;
    final empty = SizedBox.square(dimension: widget.size);
    final text = _texts[widget.icon];
    if (text == null) {
      _text(widget.icon).then((_) => _again());
      return empty;
    }
    final painted = _painted(text, c, widget.ink);
    final info = _pictures[painted];
    if (info == null) {
      _load(painted).then((_) => _again());
      return empty;
    }
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(painter: _IconPainter(info)),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.info);
  final PictureInfo info;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / info.size.width, size.height / info.size.height)
      ..drawPicture(info.picture)
      ..restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.info != info;
}
