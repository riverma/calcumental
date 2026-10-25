// Khelo's type (src/type.css). One set of faces for both aesthetics.
//
// Rozha One is the poster voice: a few words at a time, large, in block lettering. Yatra One
// is the sign painter's hand, for labels. Everything you actually read is Baloo 2.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'tokens.dart';

const rozha = 'Rozha One';
const yatra = 'Yatra One';
const baloo = 'Baloo 2';

/// Baloo 2 is variable: the weight is set on the axis as well as named, so every renderer
/// draws the weight asked for.
TextStyle balooAt(double weight) => TextStyle(
  fontFamily: baloo,
  fontWeight: FontWeight.values[(weight ~/ 100) - 1],
  fontVariations: [FontVariation('wght', weight)],
);

/// `clamp(min, base + vw, max)` from the CSS, at this width.
double _clamp(double min, double base, double vw, double max, double width) =>
    (base + vw * width / 100).clamp(min, max).toDouble();

class KhType {
  KhType({required this.c, required double width, required this.compact, required this.devanagari})
    : posterSize = _clamp(52, 24, 8, 128, width),
      h1Size = _clamp(44, 25.6, 5, 84, width),
      h2Size = _clamp(32, 22.4, 2.4, 46, width);

  final KhColors c;
  final bool compact;
  final bool devanagari;
  final double posterSize, h1Size, h2Size;

  /// --shadow-block: the letter's painted extrusion, down and right, 0.08em deep. Five steps
  /// of the side colour, three of the base. Hard edges, no blur.
  List<Shadow> block(double size) => [
    for (var i = 1; i <= 8; i++)
      Shadow(offset: Offset(0.01 * i * size, 0.01 * i * size), color: i <= 5 ? c.blockSide : c.blockBase),
  ];

  /// --shadow-block-quiet: the same block in the ink's own colour at 14%, for a title on a band.
  List<Shadow> quietBlock(double size, Color ink) => [
    for (var i = 1; i <= 5; i++)
      Shadow(offset: Offset(0.01 * i * size, 0.01 * i * size), color: ink.withValues(alpha: 0.14)),
  ];

  double get _tight => devanagari ? 1.15 : 1.05;

  /// `.kh-poster`: the one block-lettered title on a view.
  TextStyle poster([double? size]) {
    final s = size ?? posterSize;
    return TextStyle(
      fontFamily: rozha,
      fontSize: s,
      height: devanagari ? 1.15 : 0.95,
      letterSpacing: -0.01 * s,
      color: c.blockFace,
      shadows: block(s),
    );
  }

  TextStyle get h2 => TextStyle(fontFamily: rozha, fontSize: h2Size, height: _tight, color: c.heading);
  TextStyle get h3 => TextStyle(fontFamily: rozha, fontSize: 26, height: devanagari ? 1.3 : 1.15, color: c.heading);

  /// `.kh-sign`: Yatra One, for labels that want a painted hand.
  TextStyle sign(double size) =>
      TextStyle(fontFamily: yatra, fontSize: size, height: 1.25, letterSpacing: 0.01 * size, color: c.body);

  TextStyle get lead => balooAt(400).copyWith(fontSize: 21, height: 1.45, color: c.body);
  TextStyle get body => balooAt(400).copyWith(fontSize: 18, height: 1.55, color: c.body);
  TextStyle get caption => balooAt(400).copyWith(fontSize: 14, height: 1.5, color: c.secondary);
  TextStyle get label => balooAt(800).copyWith(fontSize: 18, height: 1.4, color: c.body);

  /// `.kh-caps`. Devanagari has no capitals, so Hindi keeps the weight and drops the tracking.
  TextStyle get caps =>
      balooAt(800).copyWith(fontSize: 13, height: 1.4, letterSpacing: devanagari ? 0 : 0.12 * 13, color: c.secondary);

  TextStyle button(double size) => balooAt(800).copyWith(fontSize: size, height: devanagari ? 1.35 : 1.1);

  /// The answer field: big and plain, so the digits read at a glance.
  TextStyle get answer => balooAt(700).copyWith(fontSize: math.max(26, h2Size * 0.8), height: 1.2, color: c.body);

  @override
  bool operator ==(Object other) =>
      other is KhType &&
      other.c == c &&
      other.compact == compact &&
      other.devanagari == devanagari &&
      other.posterSize == posterSize;

  @override
  int get hashCode => Object.hash(c, compact, devanagari, posterSize);
}
