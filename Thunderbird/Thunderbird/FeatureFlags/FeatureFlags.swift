//
//  FeatureFlags.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/6/25.
//

import Foundation

public struct FeatureFlags: Sendable, Decodable {
    public var featureList: [String] = ["featureX", "FeatureY"]
    //False = feature is turned off
    public var featureSettings: [String: Bool]

    public init(distribution: Distribution) async {
        featureSettings = featureList.reduce(into: [:], { (dict, number) in
            dict[number] = false
        })
        var storedSettings: [String: Bool]
        switch distribution {
        case .debug:
            storedSettings = UserDefaults().dictionary(forKey: "featureListDebug") as! [String : Bool]
        case .appstore:
            storedSettings = UserDefaults().dictionary(forKey: "featureListAppStore") as! [String : Bool]
        case .beta:
            storedSettings = UserDefaults().dictionary(forKey: "featureListBeta") as! [String : Bool]
        }
        featureSettings.merge(storedSettings) {(current, new) in new}

        var remoteSettings: [String: Bool]
        //if allowed to use url
        if(true){
            remoteSettings = (try? await getURLSettings(distribution: distribution)) ?? [:]
        }
        featureSettings.merge(remoteSettings) {(current, new) in new}
    }

    public func getURLSettings(distribution: Distribution) async throws -> [String:Bool]{
        var url: URL

        switch distribution {
        case .debug:
            url = URL(string: "")!
        case .appstore:
            url = URL(string: "")!
        case .beta:
            url = URL(string: "")!
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(Response.self, from: data)
        return response.flags
    }
}

struct Response: Decodable{
    let flags: [String: Bool]
}
