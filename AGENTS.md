# Chomp workflow

## Development

- Treat `project.yml` as the source of truth; run `xcodegen generate` after changing sources, targets, or settings. Keep generated projects and build output ignored.
- Keep app code in `Sources` and build into `build/`, matching the VS Code tasks. Preserve the compact native panel and existing cat artwork.
- Chomp holds original file URLs in memory, not copied file contents. Do not promise persistent storage or delete originals when clearing the belly.
- Before finishing a code change, build with the README command and run `git diff --check`. There is currently no test target; add focused regression tests when adding testable behavior, and include them in the scheme and release checks.
- For file-handling changes, check opening multiple files, duplicate suppression, thumbnails, cancelled drags, successful copy/move removal, and empty/full cat animation in the running app. Preserve sandbox permissions unless the feature requires a deliberate change.
- Never run `Scripts/reset.sh` as routine verification: it clears app data and permission choices.

## Documentation

- Keep README concise: icon and tagline, requirements, implemented features, install, first launch, and build/release commands. Keep the original icon intact.
- Document that the belly lasts for the current session and that the destination controls copy/move behavior.
- Release packages are ad-hoc signed and not notarized. Scope quarantine advice to a trusted `Chomp.app`; never remove quarantine automatically.

## Release and Homebrew

1. When a release is requested, check existing releases in `durklas0x/chomp`, choose an unused semantic version, update `MARKETING_VERSION`, increment `CURRENT_PROJECT_VERSION`, and update the workflow default, README example, and `.github/release-notes.md`.
2. Run the README build/package command, any tests, and `git diff --check`, then commit and push the approved changes to `main`. Check which authenticated account has write access to the repository; use its token through `gh auth token --user ACCOUNT` without printing it or changing global account selection.
3. Dispatch `.github/workflows/release.yml` with that version and watch it finish. It builds both architectures, checks bundle version/signatures/architectures, and publishes the ZIP and SHA-256 file. Retry only against the corrected commit when fixing a failed run.
4. Download both published assets and run `Scripts/verify-release.sh VERSION ZIP`. Verify the published bytes rather than a local rebuild. Verification extracts into a directory without an `.app` suffix so it does not register a competing copy.
5. Refresh `durklas0x/homebrew-tap`; generate `Casks/chomp.rb` with `Scripts/verify-release.sh VERSION ZIP CASK_PATH`. Use the `durklas0x` account for the tap, obtaining its token without printing it. Commit and push the verified cask, refresh the local tap, then run `brew audit --cask --strict durklas0x/tap/chomp` and `brew fetch --cask durklas0x/tap/chomp`.
6. A release is complete only after publishing and tap verification succeed. Finish with its release link and `brew update` / `brew upgrade --cask durklas0x/tap/chomp`.
