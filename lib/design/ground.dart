// The page ground and the ornament on it.
//
// `.kh-canvas`: Mela is noon sun pooling top-left on cream paper; Raat is deep neel overhead
// with a warm glow on the horizon. `.kh-kangura` is the stepped temple border painted along
// a truck's roofline. Both are static: nothing here moves, and none of it is in the
// accessibility tree.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'theme.dart';
import 'tokens.dart';

class KhGround extends StatelessWidget {
  const KhGround({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GroundPainter(Kh.of(context).c.ground, Kh.of(context).c.canvas), child: child);
}

class _GroundPainter extends CustomPainter {
  _GroundPainter(this.g, this.flat);
  final Ground g;
  final Color flat;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = flat);

    // A CSS gradient angle: 180deg runs top to bottom, 170deg leans a little to the right.
    final a = (g.washAngle - 90) * math.pi / 180;
    final dir = Offset(math.cos(a), math.sin(a));
    final half = (size.width * dir.dx.abs() + size.height * dir.dy.abs()) / 2;
    final centre = rect.center;
    // The gradient line runs through the centre, long enough to reach both corners, as in CSS.
    canvas.drawRect(
      rect,
      Paint()..shader = ui.Gradient.linear(centre - dir * half, centre + dir * half, g.wash, g.washStops),
    );

    final glow = g.glow;
    final c = Offset(glow.centre.dx * size.width, glow.centre.dy * size.height);
    final rx = glow.radius.width * size.width, ry = glow.radius.height * size.height;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(1, ry / rx);
    canvas.drawCircle(
      Offset.zero,
      rx,
      Paint()
        ..shader = RadialGradient(
          colors: [glow.color, glow.color.withValues(alpha: 0)],
          stops: [0, glow.reach],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: rx)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GroundPainter old) => old.g != g || old.flat != flat;
}

/// `.kh-kangura`: the stepped border, 44×22 per tile. Flip it for the bottom edge.
class Kangura extends StatelessWidget {
  const Kangura({super.key, this.down = false, this.height = 22});
  final bool down;
  final double height;

  @override
  Widget build(BuildContext context) {
    final strip = SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _KanguraPainter(Kh.of(context).c.kangura)),
    );
    return ExcludeSemantics(child: down ? Transform.flip(flipY: true, child: strip) : strip);
  }
}

class _KanguraPainter extends CustomPainter {
  _KanguraPainter(this.k);
  final ({Color base, Color step, Color line, Color dot}) k;

  // patterns.css, in its own 32×16 units: a base band, three stepped tiers, a dot.
  static final _steps = Path()
    ..moveTo(4, 12)
    ..lineTo(4, 9)
    ..lineTo(8, 9)
    ..lineTo(8, 6)
    ..lineTo(12, 6)
    ..lineTo(12, 3)
    ..lineTo(20, 3)
    ..lineTo(20, 6)
    ..lineTo(24, 6)
    ..lineTo(24, 9)
    ..lineTo(28, 9)
    ..lineTo(28, 12)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.height / 16;
    final tile = 32 * unit;
    final base = Paint()..color = k.base;
    final step = Paint()..color = k.step;
    final line = Paint()
      ..color = k.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final dot = Paint()..color = k.dot;
    canvas.clipRect(Offset.zero & size);
    for (var x = 0.0; x < size.width; x += tile) {
      canvas.save();
      canvas.translate(x, 0);
      canvas.scale(unit);
      canvas.drawRect(const Rect.fromLTWH(0, 12, 32, 4), base);
      canvas.drawPath(_steps, step);
      canvas.drawPath(_steps, line..strokeWidth = 1);
      canvas.drawCircle(const Offset(16, 7.5), 1.6, dot);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_KanguraPainter old) => old.k != k;
}
