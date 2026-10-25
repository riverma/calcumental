// The attention gate, after Khelo's tools/check-attention.mjs. Nothing in this app appears
// on its own, moves on its own, or keeps count of you. A principle nobody checks is a
// preference, so this checks it: the Dart in lib/, the web shell, and the words the app says.
//
//   dart run tool/check_attention.dart
//
// The test is not "is it dismissible" but: did the person cause this, here, now?

import 'dart:io';

/// Matched as use, not mention: comments are blanked first, so a comment explaining why
/// something is refused does not trip the gate that refuses it.
final _bannedCode = <(RegExp, String)>[
  (RegExp(r'\bTimer\s*\('), 'Timer: something that happens later without a press'),
  (RegExp(r'\bTimer\.periodic\b'), 'Timer.periodic: something recurring that nobody started'),
  (RegExp(r'\bStream\.periodic\b'), 'Stream.periodic: same'),
  (RegExp(r'Future\.delayed\s*\('), 'Future.delayed: an action that fires on a clock, not a press'),
  (RegExp(r'\.repeat\s*\('), 'an animation that loops'),
  (RegExp(r'autofocus\s*:\s*true'), 'autofocus: moves the caret out from under someone on open'),
  (RegExp(r'\bStopwatch\b|DateTime\.now\(\)'), 'a clock: play here is never timed'),
  (RegExp(r'SemanticsService\.announce|sendAnnouncement'), 'an announcement nobody asked for'),
  (RegExp(r'\bshowDialog\b|\bshowGeneralDialog\b|\bshowModalBottomSheet\b'), 'a dialog the person did not open'),
  (RegExp(r'\bSnackBar\b|\bToast\b'), 'a toast: feedback sits where the person caused it'),
  (RegExp(r'HapticFeedback\.(heavy|vibrate)'), 'a buzz that summons'),
];

final _bannedShell = <(RegExp, String)>[
  (RegExp(r'(^|[^\w.])alert\s*\('), 'alert(): a modal the person did not open'),
  (RegExp(r'(^|[^\w.])confirm\s*\('), 'confirm(): same, and it steals focus'),
  (RegExp(r'(^|[^\w.])setInterval\s*\('), 'setInterval: something recurring that nobody started'),
  (RegExp(r'new\s+Notification\s*\(|Notification\.requestPermission|\.pushManager\b'), 'a push notification'),
  (RegExp(r'''<meta[^>]*(maximum-scale|user-scalable\s*=\s*(no|0))'''), 'a viewport that disables pinch zoom'),
];

/// Compulsion, as copy. Khelo builds none of these, even when asked.
final _bannedWords = RegExp(
  r'\b(streaks?|points?|XP|scores?|leaderboards?|ranks?|levels? up|lives|energy|hurry|don.t miss|'
  r'come back tomorrow|keep your|you lost|wrong!|racha|puntos|marcador|स्कोर|अंक)\b',
  caseSensitive: false,
);

/// Pictographic emoji and the presentation selector. Khelo draws its art; it never borrows
/// a platform's.
final _emoji = RegExp(r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{2B50}\u{2B55}\u{FE0F}]', unicode: true);

String _blankComments(String src) {
  // Block comments, then line comments (but not inside a URL like https://).
  var out = src.replaceAllMapped(RegExp(r'/\*[\s\S]*?\*/'), (m) => m[0]!.replaceAll(RegExp(r'[^\n]'), ' '));
  out = out.replaceAllMapped(RegExp(r'(^|[^:])//.*$', multiLine: true), (m) => m[1]!);
  return out;
}

void main() {
  final fails = <String>[];
  var scanned = 0;

  void scan(File f, List<(RegExp, String)> rules, {bool words = false}) {
    scanned++;
    final raw = f.readAsStringSync();
    final code = (f.path.endsWith('.html') ? raw : _blankComments(raw)).split('\n');
    final rawLines = raw.split('\n');
    for (var i = 0; i < code.length; i++) {
      final line = code[i];
      for (final (re, why) in rules) {
        if (re.hasMatch(line)) fails.add('${f.path}:${i + 1}  $why\n      ${rawLines[i].trim()}');
      }
      if (_emoji.hasMatch(rawLines[i])) fails.add('${f.path}:${i + 1}  an emoji: draw it instead\n      ${rawLines[i].trim()}');
      if (words) {
        // Only what the app says: the string literals.
        for (final lit in RegExp(r"""'([^'\\]|\\.)*'""").allMatches(line)) {
          final m = _bannedWords.firstMatch(lit[0]!);
          if (m != null) fails.add('${f.path}:${i + 1}  "${m[0]}": compulsion as copy\n      ${rawLines[i].trim()}');
        }
      }
    }
  }

  for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
    if (f.path.endsWith('.dart')) scan(f, _bannedCode, words: f.path.contains('l10n'));
  }
  for (final f in Directory('web').listSync().whereType<File>()) {
    if (f.path.endsWith('.html') || f.path.endsWith('.js') || f.path.endsWith('.json')) scan(f, _bannedShell);
  }
  for (final f in Directory('assets/icons').listSync().whereType<File>()) {
    scan(f, const []);
  }

  stdout.writeln('scanned $scanned files');
  if (fails.isNotEmpty) {
    stderr.writeln('\nFAIL: ${fails.length} attention violation(s):');
    for (final f in fails) {
      stderr.writeln('   $f');
    }
    stderr.writeln('\nNothing here appears on its own. Play is invited, never pulled.');
    exit(1);
  }
  stdout.writeln('OK: nothing here appears unasked, moves on its own, or keeps count.');
}
