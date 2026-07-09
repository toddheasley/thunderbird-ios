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
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(mailboxManager.mailboxes) { mailbox in
                HStack {
                    Text(mailbox.name)
                    Spacer()
                }
            }

            .padding(.horizontal)
        } label: {
            HStack {
                AvatarView(emailAddress: EmailAddress(mailboxManager.account.name), bubbleColor: .accent)
                VStack(alignment: .leading) {
                    Text(mailboxManager.account.name)
                        .font(.body)
                    Text(mailboxManager.account.name)
                        .font(.caption2)
                }.padding(.horizontal)
                    .foregroundStyle(.black)
                Spacer()
                if (!isExpanded) {
                    Text("3")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .foregroundColor(.accent)
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    .accent,
                                    style: StrokeStyle(
                                        lineWidth: 1
                                    )
                                )
                                .frame(width: 20, height: 17)

                        }
                }
            }

        }.safeAreaPadding(.leading)
    }
}

#Preview {
    @Previewable @State var mailboxes: MailboxManager = MailboxManager(account: Account("temp@email.com"))
    AccountFolderDisclosureView()
}
