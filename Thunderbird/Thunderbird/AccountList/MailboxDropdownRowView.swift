//
//  MailboxDropdownRowView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 5/7/26.
//

import Account
import SwiftUI

// TODO: Connect to actual account and folder structure
// Includes unread count with static number currently
struct MailboxDropdownRowView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    var mailboxName: String
    var iconName: String

    var body: some View {
        DisclosureGroup {
            ForEach(accounts.allAccounts) { account in
                HStack {
                    RoundedRectangle(cornerRadius: 22.0)
                        .fill(Color.random)
                        .frame(width: 6, height: 22)
                    Text(account.name)
                        .font(.subheadline)
                    Spacer()
                    Text("3")
                        .font(.caption2)
                        .padding(.horizontal, 5)
                        .foregroundColor(.muted)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.muted)
                        )

                }.padding(.horizontal)
            }
        } label: {
            Label(mailboxName, systemImage: iconName)
        }
    }
}

#Preview {
    @Previewable @State var accounts: Accounts = Accounts()
    MailboxDropdownRowView(mailboxName: "Inbox", iconName: "tray").environment(accounts)
}
