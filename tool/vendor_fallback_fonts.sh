#!/bin/sh
# Copies the Noto fallback fonts Flutter's web engine would otherwise fetch from Google into
# web/fonts/fallback/, at the same paths, so the built app never makes that request. Run once
# after a Flutter upgrade (the paths are versioned), then commit the files. All are SIL OFL 1.1.
#
#   flutter build web --no-web-resources-cdn && sh tool/vendor_fallback_fonts.sh
#
# Emoji are left out: Khelo draws its art and refuses emoji, and the only text anyone types
# here is digits. CJK is left out too: it runs to tens of megabytes, and nothing here is
# written in it.
set -eu
JS=build/web/main.dart.js
OUT=web/fonts/fallback
grep -oE 'A\.[a-zA-Z]+\("(Noto Sans|Noto Sans (Devanagari|Arabic|Hebrew|Thai|Symbols|Symbols 2|Math)","[^"]+"\)' "$JS" \
  | sed -E 's/.*","([^"]+)"\)/\1/' | sort -u | while read -r path; do
  mkdir -p "$OUT/$(dirname "$path")"
  [ -s "$OUT/$path" ] || curl -sfL "https://fonts.gstatic.com/s/$path" -o "$OUT/$path"
  echo "$path"
done
curl -sfL https://raw.githubusercontent.com/notofonts/noto-fonts/main/LICENSE -o "$OUT/OFL.txt" || true
du -sh "$OUT"
