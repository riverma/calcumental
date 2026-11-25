// The puzzles. A port of the web app's generators (riverma/math, script.js), with the same
// ranges, so a level means the same thing in both.

import 'dart:math';

enum Op { multiply, add, subtract, divide }

enum Mode { add, subtract, multiply, divide, mixed }

enum Level { easy, medium, hard }

enum Scoring { exact, rough }

const opSymbol = {Op.multiply: '×', Op.add: '+', Op.subtract: '−', Op.divide: '÷'};

class Problem {
  const Problem(this.a, this.b, this.op);
  final int a;
  final int b;
  final Op op;

  /// Division problems are built from their quotient, so every answer is a whole number.
  int get answer => switch (op) {
    Op.multiply => a * b,
    Op.add => a + b,
    Op.subtract => a - b,
    Op.divide => a ~/ b,
  };

  String get text => '$a ${opSymbol[op]} $b';

  @override
  bool operator ==(Object other) => other is Problem && other.a == a && other.b == b && other.op == op;

  @override
  int get hashCode => Object.hash(a, b, op);
}

class Problems {
  Problems([Random? random]) : _r = random ?? Random();
  final Random _r;

  int _int(int lo, int hi) => lo + _r.nextInt(hi - lo + 1);

  (int, int) _multiply(Level l) => switch (l) {
    Level.easy => (_int(2, 9), _int(2, 9)),
    Level.medium => _r.nextBool() ? (_int(2, 9), _int(10, 99)) : (_int(10, 99), _int(2, 9)),
    Level.hard => (_int(10, 99), _int(10, 99)),
  };

  (int, int) _add(Level l) => switch (l) {
    Level.easy => (_int(2, 20), _int(2, 20)),
    Level.medium => (_int(10, 99), _int(10, 99)),
    Level.hard => (_int(100, 999), _int(100, 999)),
  };

  (int, int) _subtract(Level l) {
    final a = switch (l) {
      Level.easy => _int(5, 30),
      Level.medium => _int(30, 200),
      Level.hard => _int(200, 999),
    };
    return (a, _int(1, a));
  }

  (int, int) _divide(Level l) {
    final (q, b) = switch (l) {
      Level.easy => (_int(2, 9), _int(2, 9)),
      Level.medium => (_int(2, 12), _int(2, 12)),
      Level.hard => (_int(2, 15), _int(3, 15)),
    };
    return (q * b, b);
  }

  Problem make(Mode mode, Level level) {
    final op = mode == Mode.mixed ? Op.values[_r.nextInt(Op.values.length)] : Op.values.byName(mode.name);
    final (a, b) = switch (op) {
      Op.multiply => _multiply(level),
      Op.add => _add(level),
      Op.subtract => _subtract(level),
      Op.divide => _divide(level),
    };
    // The bigger number comes first: 11 × 9, not 9 × 11. It is the easier way round to hold in
    // your head. Subtraction and division already read that way (nothing goes below zero, and
    // the dividend is a multiple of the divisor), so only the order of × and + needs fixing.
    final swap = (op == Op.multiply || op == Op.add) && b > a;
    return swap ? Problem(b, a, op) : Problem(a, b, op);
  }

  List<Problem> set(Mode mode, Level level, int count) => [for (var i = 0; i < count; i++) make(mode, level)];
}

/// "Close enough" allows 5% either way, and never less than 1.
bool isCorrect(int expected, int given, Scoring scoring) {
  if (scoring == Scoring.exact) return given == expected;
  final tolerance = max(1.0, expected.abs() * 0.05);
  return (given - expected).abs() <= tolerance;
}

/// What a person typed, as a number: digits, and a minus only at the front. Anything else,
/// including a bare minus, is not an answer yet.
int? parseAnswer(String raw) {
  final t = raw.trim();
  if (!RegExp(r'^-?\d{1,9}$').hasMatch(t)) return null;
  return int.parse(t);
}
