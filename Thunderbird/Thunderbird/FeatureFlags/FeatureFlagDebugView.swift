//
//  FeatureFlagDebugView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/14/25.
//
import SwiftUI

struct FeatureFlagDebugView: View {
    @Environment(FeatureFlags.self) private var flags: FeatureFlags
    @State private var allowRemoteFlags = false
    var body: some View {
        VStack{
            Toggle("Allow remote feature flags", isOn: $allowRemoteFlags).padding()
            List(flags.featureList, id: \.self){ string in
                SettingRowView(string, flags.flagForKey(key: string))
            }
        }.onChange(of: allowRemoteFlags){
            flags.setAllowRemoteFlags(allowRemote: allowRemoteFlags)
        }.task{
            allowRemoteFlags = flags.allowRemote
        }

    }
}

struct SettingRowView: View {
    @Environment(FeatureFlags.self) private var flags: FeatureFlags
    init(_ flagName: String, _ onState: Bool){

        self.flagName = flagName
        self.isOn = onState
    }
    @State private var isOn: Bool

    private var flagName: String


    var body: some View {
        HStack{
            Toggle(flagName, isOn:$isOn)

        }.onChange(of: isOn){
            flags.setFlagForKey(key: flagName, val: isOn)
        }

    }
}


#Preview("Feature Flag Settings") {
    @Previewable @State var flags: FeatureFlags = FeatureFlags(distribution: .current)

    FeatureFlagDebugView()
        .environment(flags)
}
