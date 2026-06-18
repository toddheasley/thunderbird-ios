//
//  ComposeHeaderView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 2/18/26.
//

import SwiftUI

struct ComposeHeaderView: View {
    @State var subject: String = ""
    @State var sender: [String] = [""]
    @State var toRecipients: [String] = []
    @State var ccRecipients: [String] = []
    @State var bccRecipients: [String] = []

    var body: some View {
        VStack {
            VStack {
                List {
                    AddressBar("From", $sender)
                    MultiAddressBar("To", $toRecipients)
                    MultiAddressBar("CC", $ccRecipients)
                    MultiAddressBar("BCC", $bccRecipients)
                    TextField("Subject", text: $subject)
                }.frame(alignment: .leading)
                    .font(.subheadline)

            }

        }
    }
}

struct AddressBar: View {
    init(
        _ header: LocalizedStringResource = "",
        _ entryText: Binding<[String]>,
    ) {
        headerText = header
        _entryText = entryText
    }
    private var headerText: LocalizedStringResource
    @Binding private var entryText: [String]

    // MARK: View
    var body: some View {
        HStack {
            Text(headerText)
            HStack {
                ForEach(entryText, id: \.self) { email in
                    EmailPill(email, $entryText)
                }
            }
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
        HStack {
            Text(headerText)
                .fixedSize()
            TextField("", text: $entryString)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .focusable()
                .onSubmit {
                    entryText.append(entryString)
                    entryString = ""
                }
        }
        VStack {
            ForEach(entryText, id: \.self) { email in
                EmailPill(email, $entryText)
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
    ComposeHeaderView(sender: ["me@me.com"], toRecipients: ["me@mer1.com", "me@mer2.com", "mer3@me.com"], bccRecipients: ["mebcc@me.com"])
}
