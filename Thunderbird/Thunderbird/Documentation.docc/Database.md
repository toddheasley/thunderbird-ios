# Database Design

Thunderbird for iOS will persist account configurations and email messages locally using a SQLite database.

## Background

[SQLite](https://www.sqlite.org) has been the de facto relational database for iOS all along, and on the Mac long before iOS. SQLite is the default backing store for Apple's own [SwiftData](https://developer.apple.com/documentation/swiftdata) and [Core Data](https://developer.apple.com/documentation/coredata), and there a handful of popular SQLite wrapper libraries (e.g., [FMDB](https://github.com/ccgus/fmdb), [GRDB](https://github.com/groue/GRDB.swift)) for using SQLite without adopting it at the framework level.

Additionally, [Thunderbird for Android](https://github.com/thunderbird/thunderbird-android) already uses SQLite for the same purpose of persisting email accounts and messages. There's a real future where Android and iOS, first, share the same SQLite schema(s), then, use the same [KMP](https://kotlinlang.org/docs/multiplatform.html) library that wraps SQLite in a unified interface for both apps.

## Use Cases

* Single schema, single database
* Export to file formats: SQLite, MBOX, CSV, JSON
* Import from SQLite file

## Message Formats

### JMAP

### IMAP

### EWS
