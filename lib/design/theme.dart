// The theme as an inherited widget: Khelo's semantic colours, its type, and the language,
// since Devanagari wants a little more line height than Latin. Mela or Raat follows the
// system until the person chooses.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core/settings.dart';
import 'tokens.dart';
import 'typography.dart';

class Kh extends InheritedWidget {
  const Kh({super.key, required this.c, required this.t, required super.child});

  final KhColors c;
  final KhType t;

  static Kh of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Kh>()!;

  /// The page's side margin.
  double get gutter => t.compact ? Space.s4 : Space.s5;

  @override
  bool updateShouldNotify(Kh old) => old.c != c || old.t != t;
}

/// The narrowest phones in use (SE, 13 mini) are 375pt wide.
const compactBreakpoint = 390.0;

class KhScope extends StatelessWidget {
  const KhScope({super.key, required this.look, required this.lang, required this.child});

  final Look look;
  final Lang lang;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final night = switch (look) {
      Look.mela => false,
      Look.raat => true,
      Look.auto => mq.platformBrightness == Brightness.dark,
    };
    final width = mq.size.width.clamp(0.0, typeWidth);
    final compact = mq.size.shortestSide < compactBreakpoint;
    // Text follows the person's own size setting, as rem does on the web, up to the point a
    // 375pt screen can still hold a problem on one line.
    final scaler = mq.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: compact ? 1.6 : 2.0);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: night ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: MediaQuery(
        data: mq.copyWith(textScaler: scaler),
        child: Kh(
          c: night ? raat : mela,
          t: KhType(c: night ? raat : mela, width: width, compact: compact, devanagari: lang == Lang.hi),
          child: child,
        ),
      ),
    );
  }
}

/// The page fills a phone in either orientation; only a desktop-wide window leaves margins,
/// so lines of text stay readable.
const maxWidth = 960.0;

/// Type sizes stop growing at a large phone's width; a wider page gets more room, not bigger
/// letters.
const typeWidth = 520.0;
