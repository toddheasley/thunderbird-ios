//
//  GeneralSettingsView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 4/17/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI
import Account

struct GeneralSettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(Accounts.self) private var accounts: Accounts

    var body: some View {
        NavigationStack {
            List {
                Section("General Settings") {

                }
                Section("accounts_heading") {
                    ForEach(accounts.allAccounts) { account in
                        HStack {
                            Text(account.name)
                            Spacer()
                            Menu {
                                Button(action: {
                                    accounts.delete(account)
                                }) {
                                    Text("account_sign_out_button")
                                }
                            } label: {
                                Label("options_button", systemImage: "ellipsis")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.black)
                            }.compositingGroup()

                        }
                    }
                    NavigationLink(destination: {
                        ManualAccount()
                    }) {
                        Label("Add Account", systemImage: "plus")
                    }.navigationLinkIndicatorVisibility(.hidden)
                }
                Section("Miscellaneous") {
                    NavigationLink("Feature Flags", destination: FeatureFlagDebugView())
                    Button(
                        "donation_support",
                        action: {
                            guard let url = URL(string: "https://www.thunderbird.net/en-US/donate/") else { return }
                            openURL(url)
                        })
                }

            }
        }.navigationTitle("settings_header")
    }
}
