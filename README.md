# Calcumental

Arithmetic puzzles to play at your own pace: times, plus, minus, divide or a mix, at three
levels, in English, Spanish or Hindi. Offline, on your own device. Nothing is counted,
timed or kept except your settings.

One Flutter codebase builds the **iPhone app** and the **web app**, both on the
[Khelo design system](https://github.com/riverma/khelo-design) v1.0.0: Mela by day, Raat by
night, following the system unless you choose. It is a recreation of
[riverma/math](https://github.com/riverma/math) with the same puzzles and Khelo's rules of
play. A set has a visible length and a real end. A wrong answer is "not quite", with
another go. There are no streaks, scores or timers.

Licence: AGPL-3.0-or-later. Khelo's tokens and icons: MIT. Fonts: SIL OFL 1.1. See `NOTICE`.

## Layout

| Path | What it is |
| --- | --- |
| `lib/core` | Pure Dart: the puzzle generators, a finite session, settings. |
| `lib/l10n` | Every word the app says, in English, Spanish and Hindi. |
| `lib/design` | Khelo in Flutter: tokens, type, the ground and kangura, icons, components. |
| `lib/screens` | The menu, play, and the ending. |
| `lib/game.dart` | The one controller, and where settings are saved (this device only). |
| `web/` | The page shell: a strict CSP, local fallback fonts, the manifest. |
| `tool/` | Build checks: attention, offline, licences, the service worker; the icon source. |

## Run

```sh
flutter --disable-analytics && dart --disable-analytics   # the CLI reports usage otherwise
flutter pub get
flutter run                                  # a simulator or a connected iPhone
flutter run -d chrome
```

On your iPhone, first choose your own Apple team in Xcode (Runner, Signing & Capabilities).
With a free Personal Team, builds expire after 7 days; rebuild to refresh.

```sh
flutter build ios --release
xcrun devicectl device install app --device <device id> build/ios/iphoneos/Runner.app
```

## Web build

```sh
flutter build web --no-web-resources-cdn --pwa-strategy=none --release
dart run tool/build_sw.dart          # precache everything, so it opens with the radio off
dart run tool/check_offline.dart     # fails on any reference to another origin
```

## Android build

```sh
flutter build apk --release      # build/app/outputs/flutter-apk/app-release.apk
```

Release builds are signed with the key named in `android/key.properties` (git-ignored; see
`android/app/build.gradle.kts`). Without it, the build falls back to the debug key, which is fine
for trying the app but not for sharing. The APK is not on Google Play; the website links to the
latest GitHub release instead.

For a release, `tool/android_release.sh` builds the APK as `build/release/Calcumental.apk`, writes
`Calcumental.apk.sha256` beside it and prints the checksum and signer fingerprint. Attach both
files to the GitHub release and paste the checksum into its notes. The website's "How can I check
the Android download?" answer lists the signer fingerprint, which never changes between releases.

## Test

```sh
flutter test                                  # core, the whole game, the small-screen guard
dart run tool/check_attention.dart            # nothing appears unasked, moves alone or counts
dart run tool/check_licenses.dart
CAPTURE=1 flutter test test/capture           # screenshots for review, in build/shots/
```

`test/small_screen_test.dart` plays every screen at 375×667 and 375×812, at normal and very
large text, in Mela and Raat, in all three languages. It fails on any overflow or any word
split across lines.

## Website

`docs/` is the landing page and privacy policy, published with the web app (at `/play/`) by `.github/workflows/pages.yml`. The landing pages in English, Spanish and Hindi are generated: edit `tool/site/build.py`, then run `python3 tool/site/build.py`.
