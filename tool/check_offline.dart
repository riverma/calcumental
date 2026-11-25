// Matheos must work with the radio off, forever. Nothing in the web build may reach the
// network: no third-party origins in the HTML, the bootstrap, the service worker or the
// manifest, and nothing anywhere that fetches from one.
//
//   dart run tool/check_offline.dart            (after flutter build web)

import 'dart:io';

const _text = ['.html', '.js', '.json', '.css', '.webmanifest', '.mjs'];

/// Our own files, where any URL at all must be on the allow-list. The engine's compiled code
/// and Flutter's loader (inlined into flutter_bootstrap.js) carry inert URLs in comments and
/// defaults; only the fetch check applies there, and the loader is checked below for the
/// settings that override those defaults.
final _ours = RegExp(r'^(index\.html|sw\.js|manifest\.json|privacy/index\.html)$');

/// The only URLs allowed to appear are ones a person may choose to open, never ones the app
/// fetches.
const _allowedLinks = [
  'https://math.riverma.com',
  'https://math.riverma.com/privacy/',
  'https://khelo-design.riverma.com',
  'https://www.gnu.org/licenses/agpl-3.0.html',
  'https://github.com/riverma/math-app',
  'https://buy.stripe.com/9B6eVe8Gf4Bt21I6HFgrS00',
  'http://www.w3.org/',
];

final _fetching = [
  RegExp(r'''<script[^>]+src=["']https?:''', caseSensitive: false),
  RegExp(r'''<link[^>]+href=["']https?:''', caseSensitive: false),
  RegExp(r'''@import\s+(?:url\()?["']https?:''', caseSensitive: false),
  RegExp(r'''\bimportScripts\(\s*["']https?:''', caseSensitive: false),
];

/// Hosts Flutter's web engine knows how to fetch from. Their names may appear in the engine
/// as defaults; what must not appear is a configuration that points at them.
final _cdnConfig = [
  RegExp(r'''canvasKitBaseUrl\s*[:=]\s*["']https?:''', caseSensitive: false),
  RegExp(r'''fontFallbackBaseUrl\s*[:=]\s*["']https?:''', caseSensitive: false),
  RegExp(r'''"useLocalCanvasKit"\s*:\s*false'''),
];

void main(List<String> args) {
  final root = Directory(args.isEmpty ? 'build/web' : args.first);
  if (!root.existsSync()) {
    stderr.writeln('No ${root.path}. Run flutter build web first.');
    exit(2);
  }
  var problems = 0;
  for (final f in root.listSync(recursive: true).whereType<File>()) {
    if (!_text.any(f.path.endsWith)) continue;
    final rel = f.path.substring(root.path.length + 1);
    final text = f.readAsStringSync();
    for (final re in [..._fetching, ..._cdnConfig]) {
      if (re.hasMatch(text)) {
        stderr.writeln('  $rel: matches ${re.pattern}');
        problems++;
      }
    }
    if (!_ours.hasMatch(rel)) continue;
    for (final m in RegExp(r'''https?://[^\s"'`)<>\\]+''').allMatches(text)) {
      final url = m[0]!.replaceAll(RegExp(r'[.,;]+$'), '');
      if (!_allowedLinks.any(url.startsWith)) {
        stderr.writeln('  $rel: unexpected URL $url');
        problems++;
      }
    }
  }
  // The loader must be told to use the local engine and local fallback fonts.
  final boot = File('${root.path}/flutter_bootstrap.js');
  final bootText = boot.existsSync() ? boot.readAsStringSync() : '';
  for (final setting in ["canvasKitBaseUrl: 'canvaskit/'", "fontFallbackBaseUrl: 'fonts/fallback/'"]) {
    if (!bootText.contains(setting)) {
      stderr.writeln('  flutter_bootstrap.js: missing $setting');
      problems++;
    }
  }
  if (!Directory('${root.path}/fonts/fallback/notosans').existsSync()) {
    stderr.writeln('  fonts/fallback is missing: run tool/vendor_fallback_fonts.sh');
    problems++;
  }
  // The engine must be here, not on a CDN.
  if (!File('${root.path}/canvaskit/canvaskit.wasm').existsSync()) {
    stderr.writeln('  canvaskit/canvaskit.wasm is missing: build with --no-web-resources-cdn');
    problems++;
  }
  stdout.writeln(
    problems == 0 ? 'offline: no network references in ${root.path}' : '$problems network reference(s) found',
  );
  exit(problems == 0 ? 0 : 1);
}
