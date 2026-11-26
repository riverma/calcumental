#!/bin/sh
# Build the App Store IPA from the last commit, in a neutral folder.
#   build/ios/ipa/Calcumental.ipa   upload this with Transporter
#
# Your signing settings (the team) are read from the file named by CALCUMENTAL_IOS_SIGNING, which
# you set when you run this script and which lives outside the project. If you keep that file
# locked (mode 000), this script unlocks it for the build and locks it again when it ends, however
# it ends. It is copied into the temporary build folder only, and removed with it.
#
# Compiled Dart code records the absolute path it was built from; building from `git archive`
# in /tmp keeps your home folder out of the build, and means the IPA holds exactly what is
# committed. Raise the build number in pubspec.yaml (`version: X.Y.Z+N`) and commit it first:
# every upload needs a higher N.
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SETTINGS="${CALCUMENTAL_IOS_SIGNING:-}"
[ -n "$SETTINGS" ] && [ -f "$SETTINGS" ] || { echo "Set CALCUMENTAL_IOS_SIGNING to your iOS signing settings file." >&2; exit 1; }
lock() { chmod 000 "$SETTINGS" 2>/dev/null || true; }
trap lock EXIT
chmod u+r "$SETTINGS"
WORK=/tmp/calcumental-ios-build/calcumental
rm -rf /tmp/calcumental-ios-build && mkdir -p "$WORK"
git -C "$ROOT" archive HEAD | tar -x -C "$WORK"
cp "$SETTINGS" "$WORK/ios/Flutter/Signing.xcconfig"
(cd "$WORK" && flutter build ipa --release)
mkdir -p "$ROOT/build/ios/ipa"
cp "$WORK/build/ios/ipa/"*.ipa "$ROOT/build/ios/ipa/Calcumental.ipa"
rm -rf /tmp/calcumental-ios-build
ls -l "$ROOT/build/ios/ipa/Calcumental.ipa"
