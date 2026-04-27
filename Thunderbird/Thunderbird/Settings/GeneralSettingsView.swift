//
//  GeneralSettingsView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 4/17/26.
//
import SwiftUI

struct GeneralSettingsView: View {
    @Environment(\.openURL) private var openURL
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Feature Flags", destination: FeatureFlagDebugView())
                Button(
                    "donation_support",
                    action: {
                        guard let url = URL(string: "https://www.thunderbird.net/en-US/donate/") else { return }
                        openURL(url)
                    })
            }
        }.navigationTitle("settings_header")
    }
}
