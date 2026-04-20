//
//  Drawer.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 4/10/26.
//

import Account
import SwiftUI

struct DrawerView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @Binding var showDrawer: Bool

    // MARK: View
    var body: some View {

        ZStack {
            if showDrawer {
                Button {
                    showDrawer.toggle()
                } label: {
                    Rectangle()
                        .fill(Color.primary.opacity(0.3))
                        .ignoresSafeArea()
                }
                .accessibilityLabel("dismiss")

                HStack {
                    VStack(alignment: .leading) {
                        ScrollView {
                            DrawerContent(showDrawer: $showDrawer)
                        }
                        Spacer()
                        NavigationLink(destination: {
                            //TODO: Settings screen
                        }) {
                            Label("settings_button", systemImage: "gearshape")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background()
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: showDrawer)
        .toolbar(showDrawer ? .hidden : .visible, for: .navigationBar)
    }
}

#Preview("Account Drawer") {
    @Previewable @State var accounts: Accounts = Accounts()
    @Previewable @State var showDrawer: Bool = true
    DrawerView(showDrawer: $showDrawer).environment(accounts)
}

//TODO: Connect to actual account and folder structure
struct DrawerContent: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @Binding var showDrawer: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Mailbox(mailboxName: "Inbox")
            Mailbox(mailboxName: "Sent")
            Divider()
            Text("Account Folders")
            ForEach(accounts.allAccounts) { account in
                AccountFolder(account: account)
            }

        }
    }
}

//TODO: Connect to actual account and folder structure
struct Mailbox: View {
    @Environment(Accounts.self) private var accounts: Accounts
    var mailboxName: String

    var body: some View {
        DisclosureGroup(mailboxName) {
            ForEach(accounts.allAccounts) { account in
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name)
                            .font(.headline)
                        if let email = account.identities.first?.emailAddress {
                            Text(String(describing: email))
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

//TODO: Connect to actual account and folder structure
struct AccountFolder: View {
    var account: Account
    var body: some View {
        DisclosureGroup(account.name) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Inbox")
                }
            }
            .padding(.horizontal)
        }
    }
}
