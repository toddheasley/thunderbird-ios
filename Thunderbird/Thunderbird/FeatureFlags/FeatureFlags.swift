//
//  FeatureFlags.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/6/25.
//

import Foundation
private let allowRemoteFlags = "allowRemoteFeatureFlags"

public enum Flag: String {
    case featureX
    case featureY
}

@MainActor
@Observable final public class FeatureFlags: Sendable {
    public var featureList: [String] = ["featureX", "featureY"]
    //False = feature is turned off
    private var featureSettings: [String: Bool] = [:]
    public var allowRemote: Bool = true
    private var defaultsKey: String

    public init(distribution: Distribution) {
        allowRemote = (UserDefaults.standard.value(forKey: allowRemoteFlags) ?? true) as! Bool
        defaultsKey = distribution.defaultsKey
        setDefaultFlags(distribution: distribution)
    }

    private func setDefaultFlags(distribution: Distribution) {
        featureSettings = featureList.reduce(
            into: [:],
            { (dict, number) in
                dict[number] = false
            })
        let storedSettings = (UserDefaults.standard.dictionary(forKey: defaultsKey) ?? [:]) as! [String: Bool]
        featureSettings.merge(storedSettings) { (current, new) in new }
        //if allowed to use url
        if allowRemote {
            Task {
                let remoteSettings: [String: Bool] = await getURLSettings(distribution: distribution)
                featureSettings.merge(remoteSettings) { (current, new) in new }
                UserDefaults.standard.setValue(featureSettings, forKey: defaultsKey)
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
        UserDefaults.standard.setValue(allowRemote, forKey: allowRemoteFlags)
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

    static func resetFeatureFlags(distribution: Distribution = .current) {
        UserDefaults.standard.removeObject(forKey: distribution.defaultsKey)
    }

    static func resetAllowRemoteFlags() {
        UserDefaults.standard.removeObject(forKey: allowRemoteFlags)
    }
}

private struct Response: Decodable {
    let flags: [String: Bool]
}

private extension Distribution {
    var defaultsKey: String {
        switch self {
        case .debug: "featureListDebug"
        case .appstore: "featureListAppStore"
        case .beta: "featureListBeta"
        }
    }
}
