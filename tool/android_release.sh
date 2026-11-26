#!/bin/sh
# Build the release APK from the last commit, in a neutral folder, and write everything a GitHub
# release needs for it:
#   build/release/Calcumental.apk          the file people download
#   build/release/Calcumental.apk.sha256   its checksum (attach this too)
# Then checks the signer's certificate against the one published on the website.
#
# The signing settings are read from the file named by CALCUMENTAL_SIGNING_PROPERTIES, which you set
# when you run this script and which lives outside the project (it holds storeFile, storePassword,
# keyAlias and keyPassword). If you keep those files locked (mode 000), this script unlocks them for
# the build and locks them again when it ends, however it ends.
#
# Why a neutral folder: compiled Dart code records the absolute path it was built from, which
# would put your home folder name inside a file you publish. Building from `git archive` in
# /tmp also means the APK contains exactly what is committed, nothing else.
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SETTINGS="${CALCUMENTAL_SIGNING_PROPERTIES:-}"
[ -n "$SETTINGS" ] && [ -f "$SETTINGS" ] || { echo "Set CALCUMENTAL_SIGNING_PROPERTIES to your signing settings file; refusing to build an APK signed with the debug key." >&2; exit 1; }
KEYSTORE=""
lock() { chmod 000 "$SETTINGS" ${KEYSTORE:+"$KEYSTORE"} 2>/dev/null || true; }
trap lock EXIT
chmod u+r "$SETTINGS"
KEYSTORE=$(sed -n 's/^storeFile=//p' "$SETTINGS")
[ -f "$KEYSTORE" ] || { echo "Keystore not found at $KEYSTORE" >&2; exit 1; }
chmod u+r "$KEYSTORE"
java -version >/dev/null 2>&1 || PATH="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/bin:$PATH"
WORK=/tmp/calcumental-build/calcumental
rm -rf /tmp/calcumental-build && mkdir -p "$WORK"
git -C "$ROOT" archive HEAD | tar -x -C "$WORK"
(cd "$WORK" && flutter build apk --release)
mkdir -p "$ROOT/build/release"
cp "$WORK/build/app/outputs/flutter-apk/app-release.apk" "$ROOT/build/release/Calcumental.apk"
rm -rf /tmp/calcumental-build
(cd "$ROOT/build/release" && shasum -a 256 Calcumental.apk > Calcumental.apk.sha256 && cat Calcumental.apk.sha256)
APKSIGNER=$(ls -d "${ANDROID_HOME:-$HOME/Library/Android/sdk}"/build-tools/*/apksigner 2>/dev/null | sort -V | tail -1)
GOT=$("$APKSIGNER" verify --print-certs "$ROOT/build/release/Calcumental.apk" | sed -n 's/.*certificate SHA-256 digest: //p' | head -1)
WANT=$(sed -n 's/^CERT_SHA256 = "\([0-9a-f]*\)".*/\1/p' "$ROOT/tool/site/build.py")
echo "signer: $GOT"
[ "$GOT" = "$WANT" ] || { echo "Signer does not match CERT_SHA256 on the website. Do not publish this APK." >&2; exit 1; }
echo "signer matches the website"
