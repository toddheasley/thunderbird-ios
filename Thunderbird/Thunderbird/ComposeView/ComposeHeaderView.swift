//
//  ComposeHeaderView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 2/18/26.
//

import SwiftUI
import Account

struct ComposeHeaderView: View {
    @Environment(Accounts.self) private var accounts: Accounts

    @State var subject: String = ""
    @State var toRecipients: [String] = []
    @State var replyToRecipients: [String] = []
    @State var ccRecipients: [String] = []
    @State var bccRecipients: [String] = []
    @State var selectedSender: UUID = UUID()
    @State var showCCBCC: Bool = false
    @State var showReplyTo: Bool = false

    var body: some View {
        VStack {
            List {
                HStack {
                    Picker("From", selection: $selectedSender) {
                        ForEach(accounts.allAccounts) { account in
                            Text(account.name).tag(account.id)
                        }
                    } currentValueLabel: {
                        Text(accounts.account(for: selectedSender)?.name ?? "")
                    }.pickerStyle(.menu)
                    Spacer()
                    if !showReplyTo {
                        Button("", systemImage: "chevron.down") {
                            showReplyTo = true
                        }.foregroundStyle(.black)
                    }
                }
                if showReplyTo {
                    MultiAddressBar("Reply To", $replyToRecipients)
                }
                HStack(alignment: .top) {
                    MultiAddressBar("To", $toRecipients)
                    if !showCCBCC {
                        Button("", systemImage: "chevron.down") {
                            showCCBCC = true
                        }.foregroundStyle(.black)
                    }
                }
                if showCCBCC {
                    MultiAddressBar("CC", $ccRecipients)
                    MultiAddressBar("BCC", $bccRecipients)
                }

                TextField("Subject", text: $subject)
            }.frame(alignment: .leading)
                .font(.subheadline)
        }
    }
}

struct MultiAddressBar: View {
    init(
        _ header: LocalizedStringResource = "",
        _ entryText: Binding<[String]>,
    ) {
        headerText = header
        _entryText = entryText
    }
    private var headerText: LocalizedStringResource
    @Binding private var entryText: [String]
    @State private var entryString: String = ""

    // MARK: View
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(headerText)
                    .fixedSize()
                TextField("", text: $entryString)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focusable()
                    .onSubmit {
                        if entryString.isEmailAddress {
                            entryText.append(entryString)
                            entryString = ""
                        }
                    }
            }
            HStackWrap {
                ForEach(entryText, id: \.self) { email in
                    EmailPill(email, $entryText)
                }
            }
        }

    }
}

struct EmailPill: View {
    init(_ email: String, _ currentEntries: Binding<[String]>) {
        emailAddress = email
        _entries = currentEntries
    }
    @State private var emailAddress: String
    @Binding private var entries: [String]

    var body: some View {
        HStack {
            Text(emailAddress)
                .fixedSize(horizontal: true, vertical: false)
            Label("Remove", systemImage: "x.circle").labelStyle(.iconOnly)
                .onTapGesture {
                    entries.remove(at: entries.firstIndex(of: emailAddress)!)
                }
        }.padding(2)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.2))
                    .stroke(.gray, lineWidth: 1)
            }
    }
}
#Preview {
    @Previewable @State var accounts: Accounts = Accounts()
    ComposeHeaderView(
        toRecipients: ["me@mer1.com", "me@mer2.com", "mer3@me.com"],
        bccRecipients: ["mebcc@me.com"]
    )
    .environment(accounts)
}
