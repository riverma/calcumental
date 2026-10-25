#!/bin/sh
# Rasterises tool/icon/icon.svg into every size iOS, Android and the web app need. Needs rsvg-convert
# (brew install librsvg).
set -eu
D=ios/Runner/Assets.xcassets/AppIcon.appiconset
python3 - "$D" <<'PY'
import json, subprocess, sys
d = sys.argv[1]
done = set()
for img in json.load(open(f'{d}/Contents.json'))['images']:
    f = img.get('filename')
    if not f or f in done:
        continue
    px = int(float(img['size'].split('x')[0]) * int(img['scale'][0]))
    subprocess.run(['rsvg-convert', '-w', str(px), '-h', str(px), '-b', '#fbf0d9', 'tool/icon/icon.svg', '-o', f'{d}/{f}'], check=True)
    done.add(f)
print(len(done), 'iOS icons')
PY
for n in 192 512; do
  rsvg-convert -w $n -h $n tool/icon/icon.svg -o web/icons/Icon-$n.png
  rsvg-convert -w $n -h $n tool/icon/icon.svg -o web/icons/Icon-maskable-$n.png
done
rsvg-convert -w 180 -h 180 tool/icon/icon.svg -o web/icons/Icon-180.png
rsvg-convert -w 32 -h 32 tool/icon/icon.svg -o web/favicon.png
for d in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
  rsvg-convert -w ${d#*:} -h ${d#*:} tool/icon/icon.svg -o android/app/src/main/res/mipmap-${d%%:*}/ic_launcher.png
done
