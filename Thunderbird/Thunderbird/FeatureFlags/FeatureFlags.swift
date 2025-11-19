//
//  FeatureFlags.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/6/25.
//

import Foundation
let allowRemoteFlags = "allowRemoteFeatureFlags"

public enum Flag: String {
    case featureX
    case featureY
}

@MainActor
@Observable final public class FeatureFlags: Sendable, Decodable {
    public var featureList: [String] = ["featureX", "featureY"]
    //False = feature is turned off
    private var featureSettings: [String: Bool] = [:]
    public var allowRemote: Bool = true
    private var defaultsKey: String

    public init(distribution: Distribution) {
        allowRemote = (UserDefaults().value(forKey: allowRemoteFlags) ?? true) as! Bool

        switch distribution {
        case .debug:
            defaultsKey = "featureListDebug"
        case .appstore:
            defaultsKey = "featureListAppStore"
        case .beta:
            defaultsKey = "featureListBeta"
        }
        setDefaultFlags(distribution: distribution)
    }

    private func setDefaultFlags(distribution: Distribution) {
        featureSettings = featureList.reduce(
            into: [:],
            { (dict, number) in
                dict[number] = false
            })
        let storedSettings = (UserDefaults().dictionary(forKey: defaultsKey) ?? [:]) as! [String: Bool]
        featureSettings.merge(storedSettings) { (current, new) in new }
        //if allowed to use url
        if allowRemote {
            Task {
                let remoteSettings: [String: Bool] = await getURLSettings(distribution: distribution)
                featureSettings.merge(remoteSettings) { (current, new) in new }
                UserDefaults().setValue(featureSettings, forKey: defaultsKey)
            }
        }

    }

    public func flagForKey(key: Flag) -> Bool {
        return featureSettings[key.rawValue] ?? false
    }
    public func setFlagForKey(key: Flag, val: Bool) {
        featureSettings[key.rawValue] = val
    }

    public func setAllowRemoteFlags(allowRemote: Bool) {
        self.allowRemote = allowRemote
        UserDefaults().setValue(allowRemote, forKey: allowRemoteFlags)
    }

    private func getURLSettings(distribution: Distribution) async -> [String: Bool] {
        var url: URL

        switch distribution {
        case .debug:
            url = URL(string: "https://thunderbird.github.io/thunderbird-ios/feature_flag_config_debug.json")!
        case .appstore:
            url = URL(string: "https://thunderbird.github.io/thunderbird-ios/feature_flag_config_appstore.json")!
        case .beta:
            url = URL(string: "https://thunderbird.github.io/thunderbird-ios/feature_flag_config_beta.json")!
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response.flags
        } catch {
            return [:]
        }
    }
}

struct Response: Decodable {
    let flags: [String: Bool]
}
