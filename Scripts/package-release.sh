#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
version="${1:?Usage: package-release.sh VERSION}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Expected a version such as 1.0.0" >&2; exit 1; }
xcodegen generate
xcodebuild -project Chomp.xcodeproj -scheme Chomp \
  -configuration Release -destination 'generic/platform=macOS' \
  -derivedDataPath build ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO \
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= \
  MARKETING_VERSION="$version" build
app=build/Build/Products/Release/Chomp.app
[[ "$(plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist")" == "$version" ]]
codesign --verify --deep --strict "$app"
architectures="$(/usr/bin/lipo -archs "$app/Contents/MacOS/Chomp")"
for architecture in arm64 x86_64; do
  [[ " $architectures " == *" $architecture "* ]] || { echo "Missing $architecture" >&2; exit 1; }
done
mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent "$app" "dist/Chomp-$version-universal.zip"
(cd dist && shasum -a 256 "Chomp-$version-universal.zip" > "Chomp-$version-universal.zip.sha256")
