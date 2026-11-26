#!/bin/sh
# Build the release APK and everything a GitHub release needs for it:
#   build/release/Calcumental.apk          the file people download
#   build/release/Calcumental.apk.sha256   its checksum (attach this too)
# Then prints the checksum and the signer's certificate fingerprint for the release notes.
# The fingerprint should match CERT_SHA256 in tool/site/build.py (it never changes).
set -eu
cd "$(dirname "$0")/.."
java -version >/dev/null 2>&1 || PATH="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/bin:$PATH"
flutter build apk --release
mkdir -p build/release
cp build/app/outputs/flutter-apk/app-release.apk build/release/Calcumental.apk
(cd build/release && shasum -a 256 Calcumental.apk > Calcumental.apk.sha256 && cat Calcumental.apk.sha256)
APKSIGNER=$(ls -d "${ANDROID_HOME:-$HOME/Library/Android/sdk}"/build-tools/*/apksigner 2>/dev/null | sort -V | tail -1)
"$APKSIGNER" verify --print-certs build/release/Calcumental.apk | grep "SHA-256 digest"
