#!/bin/bash
set -euo pipefail
version="${1:?Usage: verify-release.sh VERSION ZIP [CASK_PATH]}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Expected a version such as 1.0.0" >&2; exit 1; }
zip="${2:?ZIP path required}"
zip="$(cd "$(dirname "$zip")" && pwd)/$(basename "$zip")"
[[ "$(basename "$zip")" == "Chomp-$version-universal.zip" ]]
expected="$(awk 'NR == 1 {print $1}' "$zip.sha256")"
[[ "$expected" =~ ^[[:xdigit:]]{64}$ ]]
actual="$(shasum -a 256 "$zip" | awk '{print $1}')"
[[ "$actual" == "$expected" ]] || { echo "Checksum mismatch" >&2; exit 1; }
verification="$(mktemp -d "${TMPDIR:-/tmp}/chomp-verification.XXXXXX")"
trap 'rm -rf "$verification"' EXIT
# Rename the extracted bundle before inspection; never launch this copy.
mkdir "$verification/Chomp.verified-bundle"
unzip -q "$zip" -d "$verification/extracted"
mv "$verification/extracted/Chomp.app/Contents" "$verification/Chomp.verified-bundle/Contents"
rmdir "$verification/extracted/Chomp.app"
app="$verification/Chomp.verified-bundle"
[[ "$(plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist")" == "$version" ]]
[[ "$(plutil -extract CFBundleIdentifier raw "$app/Contents/Info.plist")" == "com.durklas0x.Chomp" ]]
codesign --verify --deep --strict "$app"
architectures="$(/usr/bin/lipo -archs "$app/Contents/MacOS/Chomp")"
for architecture in arm64 x86_64; do
  [[ " $architectures " == *" $architecture "* ]] || { echo "Missing $architecture" >&2; exit 1; }
done
if [[ -n "${3:-}" ]]; then
  mkdir -p "$(dirname "$3")"
  cat > "$3" <<EOF
cask "chomp" do
  version "$version"
  sha256 "$actual"

  url "https://github.com/durklas0x/chomp/releases/download/v#{version}/Chomp-#{version}-universal.zip"
  name "Chomp"
  desc "Cat that holds files for convenient drag and drop"
  homepage "https://github.com/durklas0x/chomp"

  depends_on macos: :tahoe

  app "Chomp.app"
end
EOF
fi
printf 'Verified Chomp %s: checksum, bundle identity/version, signature, arm64 and x86_64.\n' "$version"
