# Chomp

[![Chomp, an orange pixel-art cat](docs/icon-preview.png)](Sources/Assets.xcassets/AppIcon.appiconset/icon1024.png)

**A little cat with a belly full of files.** Feed Chomp your files, then drag them out wherever you need them.

Requires macOS 27+; release builds include Apple Silicon and Intel binaries.

## Overview

Chomp lives in the Dock and menu bar, keeping files within reach while you move between windows.

- **Feed the cat:** drop files onto Chomp’s Dock icon, or open them with Chomp.
- **Open its belly:** click the menu-bar icon to see a compact floating panel with filenames, thumbnails, and a file count.
- **Drag files out:** drag a file into Finder or another app. A successful copy or move removes it from the belly; cancelling keeps it there.
- **A happy, full cat:** the Dock cat animates differently when its belly contains files.
- **No duplicates:** opening the same file URL again adds it only once.

The belly holds references to your original files for the current session. Adding a file leaves it in place; the destination determines how a drag copies or moves it. Quitting clears the list.

## Install

Download a published ZIP from [Releases](https://github.com/durklas0x/chomp/releases), unzip it, and move `Chomp.app` to Applications.

Or install through Homebrew:

```sh
brew install --cask durklas0x/tap/chomp
```

## First launch

Release packages are ad-hoc signed, **not notarized**. If macOS blocks Chomp, try opening it once, then use **System Settings → Privacy & Security → Open Anyway** ([Apple’s instructions](https://support.apple.com/102445)).

If macOS reports it as damaged or the approval option is unavailable, and you trust the release, remove quarantine from **Chomp only**:

```sh
xattr -dr com.apple.quarantine /Applications/Chomp.app
```

Open Chomp, feed it a file through the Dock icon or **Open With**, then click its menu-bar icon to open the belly. Close the panel with its × button or click the menu-bar icon again.

## Build / release

Install Xcode 27+ and XcodeGen, then:

```sh
xcodegen generate
xcodebuild -project Chomp.xcodeproj -scheme Chomp -configuration Debug -destination 'platform=macOS' -derivedDataPath build CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= build
```

Open `Chomp.xcodeproj` to run, or use the included VS Code tasks with `xcode-build-server`. There is currently no automated test target.

To build and verify a universal release package locally:

```sh
bash Scripts/package-release.sh 1.0.0
```

Run the **Release** GitHub Action with the matching version, or push a `v1.0.0` tag. It builds both architectures, verifies the bundle version and signature, and publishes `Chomp-VERSION-universal.zip` with its SHA-256 checksum. The workflow uses GitHub’s [Xcode 27 runner](https://github.com/actions/runner-images/blob/main/images/macos/xcode-27-arm64-Readme.md).

Download both published assets, then verify them and generate the tap cask:

```sh
bash Scripts/verify-release.sh 1.0.0 /path/to/Chomp-1.0.0-universal.zip /path/to/homebrew-tap/Casks/chomp.rb
```

The checksum file must be beside the ZIP. See [AGENTS.md](AGENTS.md) for version bumps, publishing, and the final Homebrew audit/fetch checks.
