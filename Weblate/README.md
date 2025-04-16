# Weblate

Package contains a Swift-based CLI target, `weblate-sync`, backed by `Weblate` library that loads available languages and translations from to the [Weblate REST API.](https://docs.weblate.org/en/latest/api.html)


Running `weblate-sync` currently loads the list of [languages supported by Weblate `tb-android` project](https://hosted.weblate.org/projects/tb-android/#languages), including translation completeness. Planned for future update, once iOS localization component(s) have been added to Weblate project:

* Compare current list of languages against Xcode project known locales
* Suggest adding (or removing) language support based on threshold of translation completeness
* Optionally add or remove suggested locales to/from Xcdoe project known locales
