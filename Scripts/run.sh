#!/bin/sh
set -e

cd "$(dirname "$0")/.."

DERIVED_DATA_PATH="build"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug/Chomp.app"

xcodebuild \
  -project Chomp.xcodeproj \
  -scheme Chomp \
  -configuration Debug \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  build

killall Chomp 2>/dev/null || true

open "$APP_PATH"
