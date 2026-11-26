#!/bin/sh
# Build the App Store IPA from the last commit, in a neutral folder.
#   build/ios/ipa/Calcumental.ipa   upload this with Transporter
#
# Compiled Dart code records the absolute path it was built from; building from `git archive`
# in /tmp keeps your home folder out of the build, and means the IPA holds exactly what is
# committed. Your team id stays in the git-ignored ios/Flutter/Signing.xcconfig, which is
# copied in for the build. Remember to raise the build number in pubspec.yaml (`version: X.Y.Z+N`)
# and commit it first: every upload needs a higher N.
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK=/tmp/calcumental-ios-build/calcumental
rm -rf /tmp/calcumental-ios-build && mkdir -p "$WORK"
git -C "$ROOT" archive HEAD | tar -x -C "$WORK"
cp "$ROOT/ios/Flutter/Signing.xcconfig" "$WORK/ios/Flutter/Signing.xcconfig"
(cd "$WORK" && flutter build ipa --release)
mkdir -p "$ROOT/build/ios/ipa"
cp "$WORK/build/ios/ipa/"*.ipa "$ROOT/build/ios/ipa/Calcumental.ipa"
rm -rf /tmp/calcumental-ios-build
ls -l "$ROOT/build/ios/ipa/Calcumental.ipa"
