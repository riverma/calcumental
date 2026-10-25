// Khelo v1.0.0 tokens (riverma/khelo-design, MIT), transcribed from src/tokens/**.
//
// Components read the semantic layer (KhColors) only, never a palette step, so every screen
// works unchanged in Mela and Raat. Values are copied, not derived: if Khelo moves a value,
// it moves here by hand, with the version above.

import 'package:flutter/widgets.dart';

Color hex(String h) => Color(int.parse('ff${h.substring(1)}', radix: 16));

/// Shared geometry and time (src/tokens/shared.css). The same in both aesthetics, so
/// switching never moves the grid.
abstract final class Space {
  static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0, s5 = 24.0, s6 = 32.0, s7 = 48.0, s8 = 72.0, s9 = 104.0;

  /// --hit: the smallest target anything interactive may have.
  static const hit = 44.0;
}

abstract final class Corner {
  static const s = 10.0, m = 16.0, l = 26.0, pill = 999.0;
}

abstract final class Stroke {
  static const normal = 2.0, bold = 3.0;
}

/// Motion answers a touch and is over before you notice it. Every easing ends at exactly 1.0.
abstract final class Motion {
  static const squish = Cubic(0.25, 0.8, 0.3, 1);
  static const settle = Cubic(0.2, 0, 0, 1);
  static const press = Duration(milliseconds: 110);
  static const settleTime = Duration(milliseconds: 220);
}

/// A duotone poster band and the ink measured to read on every stop.
class Band {
  const Band(this.colors, this.stops, this.ink);
  final List<Color> colors;
  final List<double> stops;
  final Color ink;

  /// 120deg in CSS: from the top left, falling toward the bottom right.
  LinearGradient get gradient => LinearGradient(
    colors: colors,
    stops: stops,
    begin: const Alignment(-0.87, -0.5),
    end: const Alignment(0.87, 0.5),
  );
}

/// The page ground (--gradient-canvas): a wash plus one glow.
class Ground {
  const Ground({required this.wash, required this.washStops, required this.washAngle, required this.glow});
  final List<Color> wash;
  final List<double> washStops;

  /// The CSS angle, in degrees.
  final double washAngle;

  /// Centre (as a fraction of the page), radii (as fractions of width and height), colour.
  final ({Offset centre, Size radius, Color color, double reach}) glow;
}

class KhColors {
  const KhColors({
    required this.raat,
    required this.canvas,
    required this.elevated,
    required this.sunk,
    required this.heading,
    required this.body,
    required this.secondary,
    required this.muted,
    required this.inverse,
    required this.borderControl,
    required this.borderSoft,
    required this.focusRing,
    required this.primary,
    required this.onPrimary,
    required this.play,
    required this.onPlay,
    required this.link,
    required this.calm,
    required this.done,
    required this.doneWash,
    required this.note,
    required this.washGenda,
    required this.washRani,
    required this.washFirozi,
    required this.washTota,
    required this.washMor,
    required this.washHaldi,
    required this.selectedFill,
    required this.onSelected,
    required this.icon,
    required this.stickerInk,
    required this.blockFace,
    required this.blockSide,
    required this.blockBase,
    required this.bands,
    required this.ground,
    required this.kangura,
    required this.dot,
  });

  final bool raat;
  final Color canvas, elevated, sunk;
  final Color heading, body, secondary, muted, inverse;
  final Color borderControl, borderSoft, focusRing;
  final Color primary, onPrimary, play, onPlay, link, calm, done, note;

  /// This app's own: a right answer's notice, a clearly green shade of `done` (Khelo's
  /// tota wash reads as olive in Mela and slate in Raat). The words carry the meaning too.
  final Color doneWash;
  final Color washGenda, washRani, washFirozi, washTota, washMor, washHaldi;
  final Color selectedFill, onSelected;

  /// The icon fills, keyed by the class Khelo's SVGs use (kh-f-genda …).
  final Map<String, Color> icon;
  final Color stickerInk, blockFace, blockSide, blockBase;
  final Map<String, Band> bands;
  final Ground ground;

  /// The kangura border's three paints: base strip, steps, outline, centre dot.
  final ({Color base, Color step, Color line, Color dot}) kangura;

  /// The rangoli grid dot.
  final Color dot;
}

// ---------------------------------------------------------------- Mela

const _paper50 = Color(0xfffff9ee), _paper100 = Color(0xfffbf0d9), _paper200 = Color(0xfff4e4c4);
const _paper300 = Color(0xffe8d2a8);
const _kajal500 = Color(0xff75637f), _kajal700 = Color(0xff4a3a5c), _kajal900 = Color(0xff2a1840);

final mela = KhColors(
  raat: false,
  canvas: _paper100,
  elevated: _paper50,
  sunk: _paper200,
  heading: _kajal900,
  body: _kajal900,
  secondary: _kajal700,
  muted: _kajal500,
  inverse: _paper50,
  borderControl: _kajal900,
  borderSoft: _paper300,
  focusRing: hex('#1660b0'),
  primary: hex('#f5a300'),
  onPrimary: _kajal900,
  play: hex('#91165f'),
  onPlay: _paper50,
  link: hex('#1660b0'),
  calm: hex('#156e76'),
  done: hex('#3c6e2a'),
  doneWash: hex('#d3edbf'),
  note: hex('#9f4721'),
  washGenda: hex('#fae2b2'),
  washRani: hex('#f5cac9'),
  washFirozi: hex('#d1e3cf'),
  washTota: hex('#dce3ba'),
  washMor: hex('#d2d6d2'),
  washHaldi: hex('#faeab7'),
  selectedFill: hex('#f7cf1d'),
  onSelected: _kajal900,
  icon: {
    'genda': hex('#f5a300'),
    'kesar': hex('#f06a1c'),
    'rani': hex('#d81b7f'),
    'firozi': hex('#11a8a4'),
    'tota': hex('#4fa82a'),
    'mor': hex('#1660b0'),
  },
  stickerInk: _kajal900,
  blockFace: _kajal900,
  blockSide: hex('#f5a300'),
  blockBase: hex('#9f4721'),
  bands: {
    'genda': Band([hex('#f7cf1d'), hex('#f5a300'), hex('#f08a1c')], const [0, 0.55, 1], _kajal900),
    'rani': Band([hex('#a6146a'), hex('#91165f')], const [0, 1], _paper50),
    'firozi': Band([hex('#4fc0b8'), hex('#11a8a4')], const [0, 1], _kajal900),
    'mor': Band([hex('#18417d'), hex('#1660b0')], const [0, 1], _paper50),
  },
  // Noon sun pooling top-left on cream paper.
  ground: Ground(
    wash: [hex('#fdf3df'), hex('#fbf0d9'), hex('#f7e6c8')],
    washStops: const [0, 0.55, 1],
    washAngle: 170,
    glow: (centre: const Offset(0.10, -0.10), radius: const Size(0.70, 0.60), color: hex('#fde9a8'), reach: 0.7),
  ),
  kangura: (base: hex('#91165f'), step: hex('#f5a300'), line: _kajal900, dot: hex('#91165f')),
  dot: _paper300,
);

// ---------------------------------------------------------------- Raat

const _sky950 = Color(0xff0c0928), _sky900 = Color(0xff14103a), _sky800 = Color(0xff1e1950);
const _sky700 = Color(0xff2b2566);
const _lamp500 = Color(0xff8e86b8), _lamp300 = Color(0xffc9c0e2), _lamp50 = Color(0xfffbefd6);

final raat = KhColors(
  raat: true,
  canvas: _sky900,
  elevated: _sky800,
  sunk: _sky950,
  heading: _lamp50,
  body: _lamp50,
  secondary: _lamp300,
  muted: _lamp500,
  inverse: _sky900,
  borderControl: _lamp300,
  borderSoft: _sky700,
  focusRing: hex('#3fe0d0'),
  primary: hex('#ffbe3d'),
  onPrimary: _sky900,
  play: hex('#ff5fb0'),
  onPlay: _sky900,
  link: hex('#72b2ff'),
  calm: hex('#3fe0d0'),
  done: hex('#93e060'),
  doneWash: hex('#1e4630'),
  note: hex('#ff8a4c'),
  washGenda: hex('#3e2f3b'),
  washRani: hex('#3e1e4f'),
  washFirozi: hex('#1c3555'),
  washTota: hex('#2b3541'),
  washMor: hex('#252d5d'),
  washHaldi: hex('#3e3643'),
  selectedFill: hex('#ffe16a'),
  onSelected: _sky900,
  icon: {
    'genda': hex('#ffbe3d'),
    'kesar': hex('#ff8a4c'),
    'rani': hex('#ff5fb0'),
    'firozi': hex('#3fe0d0'),
    'tota': hex('#93e060'),
    'mor': hex('#72b2ff'),
  },
  // A dark shadow vanishes on a dark sky, so Raat's offset is the pink echo of a neon sign.
  stickerInk: hex('#953b7b'),
  blockFace: _lamp50,
  blockSide: hex('#ff5fb0'),
  blockBase: hex('#782f61'),
  bands: {
    'genda': Band([hex('#ffe16a'), hex('#ffbe3d'), hex('#ff8a4c')], const [0, 0.55, 1], _sky900),
    'rani': Band([hex('#ff6fb8'), hex('#ff5fb0')], const [0, 1], _sky900),
    'firozi': Band([hex('#5ae6d8'), hex('#3fe0d0')], const [0, 1], _sky900),
    'mor': Band([hex('#8cc0ff'), hex('#72b2ff')], const [0, 1], _sky900),
  },
  // Deep neel overhead, a warm glow on the horizon where the fair is still lit.
  ground: Ground(
    wash: const [_sky950, _sky900, _sky800],
    washStops: const [0, 0.45, 1],
    washAngle: 180,
    glow: (centre: const Offset(0.5, 1.15), radius: const Size(0.90, 0.45), color: const Color(0x995a2a6e), reach: 0.7),
  ),
  kangura: (base: hex('#ff5fb0'), step: hex('#ffbe3d'), line: _sky950, dot: hex('#782f61')),
  dot: _sky700,
);
