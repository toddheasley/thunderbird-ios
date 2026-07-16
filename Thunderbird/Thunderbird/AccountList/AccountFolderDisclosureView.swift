//
//  AccountFolderDisclosureView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 5/8/26.
//

import SwiftUI
import Account

struct AccountFolderDisclosureView: View {
    @Environment(MailboxManager.self) private var mailboxManager: MailboxManager
    @State var isExpanded: Bool = false
    @State var unreadCount: Int = 0
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(mailboxManager.mailboxes) { mailbox in
                HStack {
                    MailboxDropdownRowView(mailbox: mailbox)
                }
            }
            .padding(.vertical, 10)
        } label: {
            HStack {
                AvatarView(emailAddress: EmailAddress(mailboxManager.account.name), bubbleColor: .accent)
                VStack(alignment: .leading) {
                    Text(mailboxManager.account.name)
                        .font(.body)
                        .truncationMode(.middle)
                    //                    Text(mailboxManager.account.name)
                    //                        .font(.caption2)
                    //                        .truncationMode(.middle)
                }.padding(.horizontal)
                    .foregroundStyle(.black)
                Spacer()
                if (!isExpanded && unreadCount > 0) {
                    UnreadCounter(unreadCount: unreadCount, hasNew: false)
                }
            }.padding(.vertical, 10)
                .safeAreaPadding(.horizontal)
        }.task {
            for mailbox in mailboxManager.mailboxes {
                unreadCount += mailbox.unreadEmails!
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    @Previewable @State var mailboxes: MailboxManager = MailboxManager(account: Account("temp@email.com"))
    AccountFolderDisclosureView().environment(mailboxes)
}
