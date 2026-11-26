# Working on Calcumental

One Flutter app for iPhone and the web, on the Khelo design system
(<https://github.com/riverma/khelo-design>). AGPL-3.0-or-later.

```sh
flutter analyze && flutter test
dart run tool/check_attention.dart
flutter build web --no-web-resources-cdn --pwa-strategy=none --release
dart run tool/build_sw.dart && dart run tool/check_offline.dart
dart run tool/check_licenses.dart
```

## Rules that are not style preferences

- **Khelo's hard constraints hold.** No streaks, points, scores, ratings, levels-up,
  timers, confetti, emoji, auto-advance or guilt copy, even when asked; say so instead.
  A set shows its length and ends. A wrong answer is never red. Nothing appears or moves
  unless the person pressed something. `tool/check_attention.dart` checks what it can.
- **Semantic tokens only.** Components read `KhColors`, never a palette value, so every
  screen works in Mela and Raat. Tokens are transcribed from Khelo by hand: when Khelo
  moves a value, update `lib/design/tokens.dart` and its version header.
- **Offline, always.** No network loads, no analytics, no CDN. The web build must pass
  `check_offline.dart`. Fonts and icons are vendored.
- **Small phones.** `test/small_screen_test.dart` must pass: 375pt, large text, every
  language and both looks.
- Screenshots of visual changes go to the owner for review before a push
  (`CAPTURE=1 flutter test test/capture` writes `build/shots/`).

## Releases

Semantic versioning. Keep the version in `pubspec.yaml`, `appVersion` in `lib/game.dart`
and `CHANGELOG.md` in step. Cut a GitHub release on every minor and major bump. Never push
without an explicit go-ahead, and review the diff for secrets first. The Apple team id lives
in `ios/Flutter/Signing.xcconfig`, which git ignores.
