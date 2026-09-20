// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountAutoView: View {
    init(_ account: Binding<Account>, path: Binding<NavigationPath> = .constant(NavigationPath())) {
        _account = account
        _path = path
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Binding private var account: Account
    @Binding private var path: NavigationPath
    @State private var jmapAccount: Account? = nil
    @State private var isRefreshing: Bool = false
    @State private var isJMAPSelected: Bool = false
    @State private var isAutoSelected: Bool = true
    @State private var error: Error? = nil {
        didSet { accountManager.error = error != nil ? AccountError(error!) : nil }
    }

    private func refresh() async {
        accountManager.error = nil
        isRefreshing = true
        do {
            jmapAccount = try? await account.jmapConfigured()
            account = try await account.autoconfigured()
        } catch {
            accountManager.error = AccountError(error) ?? .autoconfig(error)
        }
        isRefreshing = false
    }

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(spacing: .spacing(.compact)) {
                Spacer()
                if let jmapAccount {
                    Toggle(isOn: $isJMAPSelected) {
                        Text("JMAP: \(jmapAccount.id)")
                    }
                    .fullToggleStyle()
                    .onChange(of: isJMAPSelected) {
                        isAutoSelected = !isJMAPSelected
                    }
                }
                Toggle(isOn: $isAutoSelected) {
                    Text("AUTO: \(account.id)")
                }
                .fullToggleStyle()
                .onChange(of: isAutoSelected) {
                    isJMAPSelected = !isAutoSelected
                }
                .padding(.bottom, density: .compact)
                .disabled(jmapAccount == nil)
                AuthorizationView($account, error: $error, isEditable: false)
                Spacer()
                Spacer()
            }
            .padding(density: .default)
        }
        .navigationTitle("auto_account_header")
        .refreshable(action: {
            await refresh()
        })
        .task {
            await refresh()
        }
    }
}

#Preview("Account Auto View") {
    @Previewable @State var accountManager: AccountManager = AccountManager()
    @Previewable @State var account: Account = .example
    @Previewable @State var path: NavigationPath = NavigationPath()

    NavigationStack(path: $path) {
        AccountAutoView($account, path: $path)
            .environment(accountManager)
    }
}
