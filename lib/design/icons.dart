// Khelo's drawn icons (assets/icons/, copied unchanged from khelo-design src/icons/), plus
// two drawn here in the same hand (48-unit grid, 2.5 outline, round joins, flat fills):
// mixed.svg, two passing arrows, and heart.svg.
//
// On the web, icons.css paints them: the outline is currentColor and each `kh-f-*` class
// takes the aesthetic's fill. Flutter's SVG renderer has no stylesheet, so the same two
// substitutions happen on the text before it is drawn. Icons are decorative: the meaning is
// always in the words beside them.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'theme.dart';

enum KhIcons { check, cross, lattu, kamal, genda, rangoli, mixed, heart }

final _sources = <KhIcons, Future<String>>{};

String _hex(Color c) => '#${(c.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}';

class KhIcon extends StatelessWidget {
  const KhIcon(this.icon, {super.key, this.size = 27, this.ink});

  final KhIcons icon;
  final double size;

  /// The outline. Defaults to the body ink, as currentColor would.
  final Color? ink;

  @override
  Widget build(BuildContext context) {
    final c = Kh.of(context).c;
    final source = _sources[icon] ??= rootBundle.loadString('assets/icons/${icon.name}.svg');
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: FutureBuilder<String>(
          future: source,
          builder: (context, snap) {
            final svg = snap.data;
            if (svg == null) return const SizedBox.shrink();
            var painted = svg.replaceAll('currentColor', _hex(ink ?? c.body));
            c.icon.forEach((name, fill) => painted = painted.replaceAll('class="kh-f-$name"', 'fill="${_hex(fill)}"'));
            return SvgPicture.string(painted, width: size, height: size);
          },
        ),
      ),
    );
  }
}
