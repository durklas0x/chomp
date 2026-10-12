#!/bin/bash
BUNDLE_ID="com.durklas0x.Chomp"

defaults delete "$BUNDLE_ID" 2>/dev/null
rm -rf ~/Library/Containers/"$BUNDLE_ID"
rm -rf ~/Library/Caches/"$BUNDLE_ID"
rm -rf ~/Library/Application\ Support/"$BUNDLE_ID"
tccutil reset All "$BUNDLE_ID"

echo "Cleared data for $BUNDLE_ID"
