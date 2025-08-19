# Feature Libraries

## `Autoconfiguration`

[Thunderbird Autoconfiguration](https://www.bucksch.org/1/projects/thunderbird/autoconfiguration), often just "autoconfig," is an XML syndication format by which email service providers advertise their public mail server settings. Mail clients, when configuring a new email account, query the account domain for an autoconfig file. The user only needs to know the account email address and password or token to set up a new mail client.

`Autoconfigruation` feature library attempts to return a configuration for a provided email address, first by querying the address domain directly, then checking the [Thunderbird autoconfig database](https://github.com/thunderbird/autoconfig), or "ISP DB."

```swift
import Autoconfiguration
import Foundation

let example: (config: ClientConfig, source: Source) = try await URLSession.shared.autoconfig("user@example.com")
```

## `JMAP`

[JSON Meta Application Protocol](https://jmap.io) (JMAP)) is a modern, API-based approach to email that uses standard HTTP requests and responses with JSON serialization for transit.

`JMAP` feature library is a _client_ implementation of both [JMAP core](https://jmap.io/spec-core.html) and [JMAP mail](https://jmap.io/spec-mail.html) protocols, with functionality tailored for use in [Thunderbird for iOS.](https://github.com/thunderbird/thunderbird-ios)
