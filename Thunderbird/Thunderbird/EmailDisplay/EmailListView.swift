//
//  EmailListView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 10/20/25.
//

import SwiftUI
import Account

struct EmailListView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @Environment(\.openURL) private var openURL

    //Hardcoded for testing
    let attributedString = try? NSMutableAttributedString(
        data: Data(
            """
            <html>
            <body>
            <h2>This is a test email with a bit of text</h2>
            <p>Its doing its best to model how an email might look</p>
            </body>
            </html>
            """.utf8),
        options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil
    )
    var body: some View {
        NavigationView {
            List(0..<10) { _ in
                NavigationLink {
                    ReadEmailView(
                        attributedString ?? NSMutableAttributedString(""),
                        "emailSender@email.org",
                        "This is the subject of the email",
                        Date()
                    )
                } label: {
                    EmailCellView()
                }
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(id: "navBar", placement: .automatic) {
                    Menu {
                        Button(
                            "account_sign_out_button",
                            action: {
                                accounts.deleteAccounts()
                            })
                        Button(
                            "donation_support",
                            action: {
                                guard let url = URL(string: "https://www.thunderbird.net/en-US/donate/") else { return }
                                openURL(url)
                            })
                    } label: {
                        Label("Options", systemImage: "ellipsis", )
                    }
                }
                ToolbarItem(placement: .automatic) {
                    NavigationLink("Settings", destination: FeatureFlagDebugView())
                }
            }
        }

    }
}

#Preview("Email Cell") {
    @Previewable @State var accounts: Accounts = Accounts()
    EmailListView().environment(accounts)

}
