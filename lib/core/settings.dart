// What the app remembers between visits: your choices, and nothing about how you did.

import 'problems.dart';

enum Lang { en, es, hi }

/// Auto follows the system's light or dark setting until you choose.
enum Look { auto, mela, raat }

const lengths = [5, 10, 20, 50];

class Settings {
  const Settings({
    this.lang = Lang.en,
    this.look = Look.auto,
    this.mode = Mode.multiply,
    this.level = Level.medium,
    this.scoring = Scoring.exact,
    this.count = 10,
  });

  final Lang lang;
  final Look look;
  final Mode mode;
  final Level level;
  final Scoring scoring;
  final int count;

  Settings copyWith({
    Lang? lang,
    Look? look,
    Mode? mode,
    Level? level,
    Scoring? scoring,
    int? count,
  }) => Settings(
    lang: lang ?? this.lang,
    look: look ?? this.look,
    mode: mode ?? this.mode,
    level: level ?? this.level,
    scoring: scoring ?? this.scoring,
    count: count ?? this.count,
  );

  Map<String, Object> toJson() => {
    'lang': lang.name,
    'look': look.name,
    'mode': mode.name,
    'level': level.name,
    'scoring': scoring.name,
    'count': count,
  };

  /// Anything unknown or missing falls back to the default, so an old or damaged file never
  /// stops the app from opening.
  factory Settings.fromJson(Map<String, Object?> j) {
    T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.where((v) => v.name == name).firstOrNull ?? fallback;
    const d = Settings();
    final count = j['count'];
    return Settings(
      lang: pick(Lang.values, j['lang'], d.lang),
      look: pick(Look.values, j['look'], d.look),
      mode: pick(Mode.values, j['mode'], d.mode),
      level: pick(Level.values, j['level'], d.level),
      scoring: pick(Scoring.values, j['scoring'], d.scoring),
      count: count is int && lengths.contains(count) ? count : d.count,
    );
  }
}
