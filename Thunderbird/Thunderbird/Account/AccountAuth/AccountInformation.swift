// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import Autoconfiguration
import SwiftUI

struct AccountInformation: View {
    init(_ path: Binding<NavigationPath>) {
        _path = path
    }

    @Binding var path: NavigationPath
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Environment(LoginDetails.self) private var loginDetails: LoginDetails
    @State private var account: Account = Account()
    @State private var showManual: Bool = true
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var error: Error?
    @State private var loginServer: Server = Server(.imap)
    @State private var loginAuth: Authorization = .none

    var body: some View {
        Form {
            TextEntryWrapper("account_server_settings_email_address_label", "your.email@example.com", $emailAddress)
                #if os(iOS)
            .keyboardType(.emailAddress)
            .submitLabel(.search)
                #endif
                //AutoconfigView($config, for: emailAddress)
                .listRowSeparator(.hidden)
            Button(action: {
                loginDetails.inProgressAccount = account
                loginDetails.enteredEmail = emailAddress
                path.append("ManualAccountSetup")
            }) {
                Text("account_server_edit_configuration")
                    .padding(5.5)
                    .frame(maxWidth: .infinity)
                    .underline()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
            if account.incomingServer?.authenticationType != nil {
                AuthorizationView($account, error: $error, isEditable: true)
                    .onChange(of: loginAuth) {
                        account.avatarColor = randomizeAvatarColor()
                        var incomingServerInfo = account.incomingServer ?? Server(.imap)
                        var outgoingServerInfo = account.outgoingServer ?? Server(.smtp)
                        incomingServerInfo.username = emailAddress
                        outgoingServerInfo.username = emailAddress
                        account.authorization = loginAuth
                        account.servers = [incomingServerInfo, outgoingServerInfo]
                        accountManager.set(account)
                    }
            }
            if error != nil || showManual {
                Button(
                    action: {
                        loginDetails.inProgressAccount = nil
                        path.append("EmailAccountTypeSelection")

                    }) {
                        Text("account_server_manual_configuration")
                            .padding(5.5)
                            .frame(maxWidth: .infinity)
                            .underline()

                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .buttonStyle(.plain)
            }
            //TEMP DEMO BUTTON
            Button(action: {
                Task {
                    guard var account: Account = try? await .autoconfigured("demoEmail@gmail.com") else {
                        return
                    }
                    account.authorization = loginAuth
                    accountManager.set(account)
                }
            }) {
                Text("Demo")
                    .padding(5.5)
                    .frame(maxWidth: .infinity)
                    .underline()

            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .buttonStyle(.borderedProminent)
        }
        .scrollContentBackground(.hidden)
        #if os(iOS)
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        #endif
        .navigationTitle("account_server_information_title")

    }
}
