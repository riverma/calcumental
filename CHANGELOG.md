# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- A landing page in English, Español and हिन्दी (`docs/`, built by `tool/site/build.py`), and a GitHub Actions workflow that builds the web app and publishes the site, with the app at `/play/`.
- An Android build: a signed APK that can be installed directly (not on Google Play), with a download button on the website that links to Google's install steps. Release signing comes from a git-ignored `android/key.properties`; without it, release builds fall back to the debug key.
- `tool/android_release.sh`, and a FAQ on the website explaining how to check the Android download (checksum and signing certificate).
- The privacy policy now lists, with green check marks, what the app does not do, and is also in Hindi.

### Fixed
- The website's Look and feel screenshots now all load: they no longer depend on a parent's height (which some browsers size to zero, so lazy images never loaded).
- Moving between screens no longer flickers: every icon is decoded once, before the first screen, instead of on each mount.

### Changed
- The privacy policy now lives at <https://calcumental.riverma.com/privacy/>, and the About page links there.
- After a "not quite", typing starts a fresh answer and backspace trims the old one; Try again is still there but no longer needed.
- Full-width buttons, quick to hit with a thumb: Let's play, Choose your own, Apply, Check, Next, Another set, Menu and Back. Try again and Show me sit side by side, half the width each, clear of the number pad. In Customize, Level, How close and How many share the width the same way, and so do Language and Look on the menu. Languages are named in full: English, Español, हिन्दी.
- The bigger number always comes first, so 11 × 9 and 120 + 87 rather than 9 × 11 and 87 + 120. Subtraction and division already read that way.
- Renamed from Mental Math to Calcumental, in every language, on the home screen, the launch screen, the About text and the privacy policy. The package name and the saved-settings key keep their old identifiers, so nothing a person has chosen is lost.

### Added
- An About page, from a small button at the foot of the menu: why the app was made and its
  version. On the web it also has a small Donate button that opens Stripe in the browser.
- A privacy policy, in English and Spanish, on the web at `/privacy/` and from a small
  "View privacy policy" button on the About page.
- iPad: tested on the iPad mini, the 13-inch iPad Pro both ways round, and Split View at
  320pt, at normal and very large text.

### Changed
- The menu's footer no longer carries the "built with love" credit, the privacy line or
  the version; they give way to the About button.
- The bundle id is now `com.riverma.math`, ready for the App Store.
- A choice tile's name shrinks to fit rather than breaking inside a word (Spanish
  "Multiplicar" in Split View with very large text).

### Security
- The web page's content security policy no longer allows inline script.
- The iOS app declares that it uses no non-exempt encryption.

## [1.0.0] - 2026-10-16

### Added
- Mental Math as one Flutter app for iPhone and the web, recreated from the web app
  (riverma/math v1.0.2) with the same puzzles: times, plus, minus, divide or mixed, at
  three levels, scored exactly or "close enough", in sets of 5, 10, 20 or 50.
- The Khelo design system (v1.0.0): Mela by day and Raat by night, following the system
  until you choose; Rozha One block lettering, Yatra One signs, Baloo 2 for reading;
  sticker buttons, the kangura border and drawn icons.
- Hindi, beside English and Spanish.
- A wrong answer is "not quite": try again, or ask to see it.
- An ending that lists every problem, what you answered, and whether it took another go.
- The web build is an offline PWA: no CDN, a precaching service worker, and a strict
  content security policy.
- Gates: offline, licences, and attention (no timers, autofocus, emoji or compulsion copy).

### Changed from the web app
- No streaks, star ratings, timing, confetti or result that moves on by itself. Khelo builds
  no compulsion mechanics; a set has a visible length and a real end instead.

[Unreleased]: https://github.com/riverma/calcumental/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/riverma/calcumental/releases/tag/v1.0.0
