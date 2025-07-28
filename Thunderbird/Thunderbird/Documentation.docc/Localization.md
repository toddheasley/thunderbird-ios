# Localization

Supporting 50+ language translations with Weblate

By adopting the same hosted [Weblate language translations]((https://hosted.weblate.org/projects/tb-android/)) that we develop for Thunderbird for Android, iOS matches with localization for the same 50+ languages.

Our source language is American English, referred to simply as "English" (en) on Weblate.

Translations of source strings happen exclusively in our shared [Weblate project](https://hosted.weblate.org/projects/tb-android/), which is automated to periodically pick up approved translation changes and submit pull requests to both Android and iOS repositories. Translation changes are then reviewed and merged into this repository by the Thunderbird team.

## Merging Weblate Changes

Weblate PRs, titled "chore(i18n): Translations update from Hosted Weblate," contain ready-to-build [Xcode strings files](https://docs.weblate.org/en/latest/formats/apple.html) for every language in the project, regardless of level of translation completeness. Xcode then indexes the strings files present in the project to dynamically build a manifest of supported localizations to package in the app bundle.

To ensure that built versions of Thunderbird for iOS match Android and only advertise support for language translations at or above 70% translation completeness, an additional step is required to prune the Xcode strings files from the Weblate PR prior to merging.

### iOS "Fix Up" Workflow

Given a pull request from Weblate:

1. Switch to Weblate PR branch `weblate:weblate-tb-android-ios-localization`.
2. Open project workspace in Xcode.
3. Run `weblate` CLI target with "My Mac" as run destination.
4. Inspect console output, confirming Xcode project is now configured to use sufficiently translated localizations.
5. Review git changes, expecting:
    * Deleted `Localizable.strings` files (one for each insufficiently translated language)
    * Dirty Xcode project file with updated list of supported localizations, if changed
6. Commit, push, run CI, review, then merge.
