// Every package Matheos ships or builds with must be free software, and compatible with
// shipping the whole as AGPL-3.0-or-later. Fails on anything outside the allow-list, or on a
// package with no licence file at all.
//
//   dart run tool/check_licenses.dart            (after flutter pub get)

import 'dart:convert';
import 'dart:io';

/// The Flutter SDK's own packages: BSD-3-Clause, shipped with the SDK.
const _sdk = {
  'flutter',
  'flutter_test',
  'flutter_driver',
  'flutter_web_plugins',
  'integration_test',
  'sky_engine',
  'fuchsia_remote_debug_protocol',
  'flutter_localizations',
};

/// Recognised by their text, since pub has no licence field.
final _kinds = <String, List<RegExp>>{
  'BSD-3-Clause': [
    RegExp(r'Redistribution and use in source and binary forms'),
    RegExp(r'Neither the name|names of its\s+contributors'),
  ],
  'BSD-2-Clause': [RegExp(r'Redistribution and use in source and binary forms')],
  'MIT': [RegExp(r'Permission is hereby granted, free of charge')],
  'Apache-2.0': [RegExp(r'Apache License,?\s+Version 2\.0')],
  'MPL-2.0': [RegExp(r'Mozilla Public License,?\s+(Version|v\.)\s*2\.0')],
  'ISC': [RegExp(r'Permission to use, copy, modify, and/or distribute this software')],
};

String? classify(String text) {
  for (final e in _kinds.entries) {
    if (e.value.every((re) => re.hasMatch(text))) return e.key;
  }
  return null;
}

void main() {
  final config = File('.dart_tool/package_config.json');
  if (!config.existsSync()) {
    stderr.writeln('Run flutter pub get first.');
    exit(2);
  }
  final packages = (jsonDecode(config.readAsStringSync())['packages'] as List).cast<Map<String, Object?>>();
  final bad = <String>[];
  var checked = 0;
  for (final p in packages) {
    final name = p['name'] as String;
    if (name == 'mental_math' || _sdk.contains(name)) continue;
    checked++;
    var uri = Uri.parse(p['rootUri'] as String);
    if (!uri.isAbsolute) uri = config.uri.resolveUri(uri);
    final dir = Directory.fromUri(uri);
    final file = [
      'LICENSE',
      'LICENSE.md',
      'LICENSE.txt',
      'COPYING',
    ].map((n) => File('${dir.path}/$n')).where((f) => f.existsSync()).firstOrNull;
    final kind = file == null ? null : classify(file.readAsStringSync());
    if (kind == null) {
      bad.add('$name: ${file == null ? 'no licence file' : 'unrecognised licence'}');
    } else {
      stdout.writeln('  $name: $kind');
    }
  }
  for (final b in bad) {
    stderr.writeln('  $b');
  }
  stdout.writeln('$checked packages checked, ${bad.length} outside the allow-list');
  if (bad.isNotEmpty) {
    stderr.writeln('\nMatheos ships only free software. Replace or remove the packages above.');
    exit(1);
  }
}
