//
//  FeatureFlags.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/6/25.
//

import Foundation

@MainActor
@Observable final public class FeatureFlags: Sendable, Decodable {
    private var featureList: [String] = ["featureX", "featureY"]
    //False = feature is turned off
    private var featureSettings: [String: Bool] = [:]
    private var allowRemote: Bool = true
    private var usingLocalDebugFlags: Bool = false

    public init(distribution: Distribution) {
        allowRemote = (UserDefaults().value(forKey: "allowRemoteFeatureFlags") ?? true) as! Bool
        usingLocalDebugFlags = (UserDefaults().value(forKey: "hasUsedDebugFlagSettings") ?? false) as! Bool
        featureSettings = featureList.reduce(into: [:], { (dict, number) in
            dict[number] = false
        })

        var defaultsKey: String
        switch distribution {
        case .debug:
            defaultsKey = "featureListDebug"
        case .appstore:
            defaultsKey = "featureListAppStore"
        case .beta:
            defaultsKey = "featureListBeta"
        }
        let storedSettings = (UserDefaults().dictionary(forKey: defaultsKey) ?? [:]) as! [String : Bool]
        featureSettings.merge(storedSettings) {(current, new) in new}
        //if allowed to use url
        if(allowRemote){
            Task {
                let remoteSettings: [String: Bool] =  await getURLSettings(distribution: distribution)
                featureSettings.merge(remoteSettings) {(current, new) in new}
            }
        }
        UserDefaults.setValue(featureSettings, forKey: defaultsKey)
    }

    public func flagForKey(key: String)->Bool{
        return featureSettings[key] ?? false
    }

    public func setAllowRemoteFlags(allowRemote: Bool){
        self.allowRemote = allowRemote
        UserDefaults.setValue(allowRemote, forKey: "allowRemoteFeatureFlags")
    }

    public func setUsingLocalFlags(usingLocal: Bool){
        self.usingLocalDebugFlags = usingLocal
        UserDefaults.setValue(allowRemote, forKey: "hasUsedDebugFlagSettings")
    }

    public func getURLSettings(distribution: Distribution) async -> [String:Bool]{
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

struct Response: Decodable{
    let flags: [String: Bool]
}
