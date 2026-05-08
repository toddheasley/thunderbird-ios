//
//  AccountFolderDisclosureView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 5/8/26.
//

import SwiftUI
import Account

struct AccountFolderDisclosureView: View {
    var account: Account
    var body: some View {
        DisclosureGroup {
            HStack {
                Text("Inbox")
                Spacer()
            }
            .padding(.horizontal)
        } label: {
            Label {
                Text(account.name)
            } icon: {
                Image(systemName: "folder")
                    .foregroundStyle(Color.random)
            }
        }
    }
}
