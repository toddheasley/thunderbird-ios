# Core Libraries

## `Weblate`

Thunderbird for iOS is adopting the same hosted [Weblate language translations](https://hosted.weblate.org/projects/tb-android) that Android already uses. The now-shared Weblate project periodically picks up translation changes and submits pull requests containing ready-to-build Xcode strings files to `thunderbird-ios`. The problem: Automated Weblate PRs contain a strings file for every language in the project, regardless of level of translation completeness. And we only want the Xcode project configured with localizations at or above 70%. (Where percent completeness is found by number of strings translated to language against total number of string in project.)

`Weblate` builds a CLI app, an "executable target," in Swift package nomenclature, that can be run from within Xcode and does exactly two things:

1. Retreive and display the current list of language translations (and current levels of completeness) from the Weblate API.
2. Optionally, delete insufficiently complete localizations from an Xcode project -- ideally, the automated Weblate PR branch.
