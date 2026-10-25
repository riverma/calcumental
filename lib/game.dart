// The app's one controller: your settings, which screen is showing, and the set in play.
// Settings are saved on this device and nowhere else. Nothing about how you did is kept.

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/problems.dart';
import 'core/session.dart';
import 'core/settings.dart';

const appVersion = '1.0.0';

enum Screen { menu, play, end }

/// Where settings live. Swapped for memory in tests.
abstract class SettingsStore {
  Future<Settings> load();
  Future<void> save(Settings s);
}

class DeviceSettings implements SettingsStore {
  static const _key = 'mentalMath.settings.v1';

  @override
  Future<Settings> load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      if (raw == null) return const Settings();
      return Settings.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } catch (_) {
      // Unreadable settings are not worth refusing to open over.
      return const Settings();
    }
  }

  @override
  Future<void> save(Settings s) async {
    try {
      await (await SharedPreferences.getInstance()).setString(_key, jsonEncode(s.toJson()));
    } catch (_) {
      // Storage may be unavailable (a private window); the app still works for this visit.
    }
  }
}

class MemorySettings implements SettingsStore {
  MemorySettings([this.saved = const Settings()]);
  Settings saved;

  @override
  Future<Settings> load() async => saved;

  @override
  Future<void> save(Settings s) async => saved = s;
}

class Game extends ChangeNotifier {
  Game({required this.store, Settings settings = const Settings(), Random? random})
    : _settings = settings,
      _problems = Problems(random);

  final SettingsStore store;
  final Problems _problems;

  Settings _settings;
  Settings get settings => _settings;

  Screen _screen = Screen.menu;
  Screen get screen => _screen;

  Session? _session;
  Session get session => _session!;

  static Future<Game> boot(SettingsStore store, {Random? random}) async =>
      Game(store: store, settings: await store.load(), random: random);

  /// The choices in the open Customize panel, not yet applied. Null while it is closed.
  Settings? _draft;
  Settings? get draft => _draft;

  void update(Settings Function(Settings) change) {
    _settings = change(_settings);
    _draft = _draft == null ? null : change(_draft!);
    store.save(_settings);
    notifyListeners();
  }

  /// Opens Customize on the saved choices, or closes it and lets the unapplied ones go.
  void toggleCustomize() {
    _draft = _draft == null ? _settings : null;
    notifyListeners();
  }

  void edit(Settings Function(Settings) change) {
    _draft = change(_draft!);
    notifyListeners();
  }

  /// Keeps the panel's choices as the default, here and next time, and closes it.
  void apply() {
    final d = _draft!;
    _draft = null;
    update((s) => s.copyWith(mode: d.mode, level: d.level, scoring: d.scoring, count: d.count));
  }

  /// "Let's play": a set from the saved choices.
  void start() {
    final s = _settings;
    _draft = null;
    _session = Session(_problems.set(s.mode, s.level, s.count), s.scoring);
    _screen = Screen.play;
    notifyListeners();
  }

  bool answer(int given) {
    final right = session.answer(given);
    notifyListeners();
    return right;
  }

  void tryAgain() {
    session.tryAgain();
    notifyListeners();
  }

  void show() {
    session.show();
    notifyListeners();
  }

  void next() {
    session.next();
    if (session.phase == Phase.ended) _screen = Screen.end;
    notifyListeners();
  }

  void stop() {
    session.stop();
    _screen = Screen.end;
    notifyListeners();
  }

  void menu() {
    _screen = Screen.menu;
    notifyListeners();
  }
}
