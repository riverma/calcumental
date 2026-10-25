// Writes build/web/sw.js: every built file precached, under a cache name hashed from their
// contents, so each deploy is a fresh cache generation. Run after flutter build web.
// A port of the web app's scripts/build-sw.mjs.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

void main() {
  final dist = Directory('build/web');
  final files =
      [
          for (final f in dist.listSync(recursive: true).whereType<File>())
            './${f.path.substring(dist.path.length + 1).replaceAll(r'\', '/')}',
        ]
        ..removeWhere((f) => f == './sw.js' || f.endsWith('.map') || f.endsWith('.symbols'))
        ..sort();

  // index.html is served for every route; list it once, explicitly.
  final assets = ['./', ...files.where((f) => f != './index.html')];

  final sink = AccumulatorSink<Digest>();
  final hasher = sha256.startChunkedConversion(sink);
  for (final f in files) {
    hasher.add(File('${dist.path}/${f.substring(2)}').readAsBytesSync());
  }
  hasher.close();
  final version = sink.events.single.toString().substring(0, 12);

  final sw = File('tool/sw_template.js')
      .readAsStringSync()
      .replaceFirst('__SW_VERSION__', version)
      .replaceFirst('__SW_ASSETS__', const JsonEncoder.withIndent('  ').convert(assets));
  File('${dist.path}/sw.js').writeAsStringSync(sw);
  stdout.writeln('sw.js: ${assets.length} assets, cache mental-math-$version');
}

class AccumulatorSink<T> implements Sink<T> {
  final events = <T>[];
  @override
  void add(T event) => events.add(event);
  @override
  void close() {}
}
