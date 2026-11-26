#!/bin/sh
# Build the release APK from the last commit, in a neutral folder, and write everything a GitHub
# release needs for it:
#   build/release/Calcumental.apk          the file people download
#   build/release/Calcumental.apk.sha256   its checksum (attach this too)
# Then prints the checksum and the signer's certificate fingerprint for the release notes.
# The fingerprint should match CERT_SHA256 in tool/site/build.py (it never changes).
#
# Why a neutral folder: compiled Dart code records the absolute path it was built from, which
# would put your home folder name inside a file you publish. Building from `git archive` in
# /tmp also means the APK contains exactly what is committed, nothing else.
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
java -version >/dev/null 2>&1 || PATH="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/bin:$PATH"
WORK=/tmp/calcumental-build/calcumental
rm -rf /tmp/calcumental-build && mkdir -p "$WORK"
git -C "$ROOT" archive HEAD | tar -x -C "$WORK"
cp "$ROOT/android/key.properties" "$WORK/android/key.properties"   # git-ignored signing settings
(cd "$WORK" && flutter build apk --release)
mkdir -p "$ROOT/build/release"
cp "$WORK/build/app/outputs/flutter-apk/app-release.apk" "$ROOT/build/release/Calcumental.apk"
rm -rf /tmp/calcumental-build
(cd "$ROOT/build/release" && shasum -a 256 Calcumental.apk > Calcumental.apk.sha256 && cat Calcumental.apk.sha256)
APKSIGNER=$(ls -d "${ANDROID_HOME:-$HOME/Library/Android/sdk}"/build-tools/*/apksigner 2>/dev/null | sort -V | tail -1)
"$APKSIGNER" verify --print-certs "$ROOT/build/release/Calcumental.apk" | grep "SHA-256 digest"
