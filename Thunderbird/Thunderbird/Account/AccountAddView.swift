// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountAddView: View {
    @Binding private var account: Account

    init(_ account: Binding<Account>, autofocus: Bool = false) {
        _account = account
        self.autofocus = autofocus
    }

    @State private var valueText: String = ""
    @State private var labelText: String = ""
    @FocusState private var isValueFocused: Bool
    @FocusState private var isLabelFocused: Bool
    private let autofocus: Bool

    private var emailAddress: EmailAddress? {
        set {
            if let newValue, newValue.value.isEmailAddress {
                account.identities = [newValue]
            } else {
                account.identities = []
            }
        }
        get { account.emailAddress }
    }

    private var isDisabled: Bool { !valueText.isEmailAddress }

    // MARK: View
    var body: some View {
        VStack(spacing: .spacing()) {
            Spacer()
            TextField("your.email@example.com", text: $valueText)
                .formInput("account_server_settings_email_address_label", isRequired: true)
                .autoFormattingDisabled()
                #if os(iOS)
            .keyboardType(.emailAddress)
            .submitLabel(.continue)
                #endif
                .focused($isValueFocused, equals: true)
                .onSubmit {
                    isLabelFocused = true
                }
            TextField("Pat Example", text: $labelText)
                .formInput("account_server_settings_email_label_label")
                .autoFormattingDisabled()
                #if os(iOS)
            .submitLabel(.continue)
                #endif
                .focused($isLabelFocused, equals: true)
                .onSubmit {
                    //Task { await search() }
                }
            HStack {
                Spacer()
                NavigationLink(destination: {
                    ContentUnavailableView("TBD", systemImage: "burst.fill")
                }) {
                    Text("next_button")
                        .padding(.horizontal, density: .compact)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isDisabled)
            }
            Spacer()
            Spacer()
            NavigationLink(destination: {
                ContentUnavailableView("TBD", systemImage: "burst.fill")
            }) {
                Text("account_server_manual_configuration")
            }
        }
        .navigationTitle("Add Account")
        .onChange(of: valueText) {

        }
        .onChange(of: labelText) {

        }
        .onAppear {
            valueText = emailAddress?.value ?? ""
            labelText = emailAddress?.label ?? ""
            isValueFocused = autofocus
        }
        .padding(density: .default)
    }
}

#Preview("Account Add View") {
    @Previewable @State var account: Account = Account("Pat Example <your.email@example.com>")

    NavigationStack {
        AccountAddView($account)
    }
}
