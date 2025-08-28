# Core Libraries

## `Weblate`

Thunderbird for iOS and Android both depend on the same hosted [Weblate language translations](https://hosted.weblate.org/projects/tb-android) for localization.

The shared Weblate project periodically picks up translation changes and submits pull requests containing ready-to-build Xcode strings files to `thunderbird-ios`. Automated Weblate PRs contain a strings file for every language in the project, regardless of level of translation completeness. But we only want the Xcode project configured with localizations at or above 70%. (Where percent completeness is found by number of strings translated to language against total number of string in project.)

`Weblate` builds a CLI app ("executable target" in Swift package nomenclature) that can be run from within Xcode and does exactly two things:

1. Retreive and display the current list of language translations (and current levels of completeness) from the Weblate API.
2. Optionally, delete insufficiently complete localizations from an Xcode project.
