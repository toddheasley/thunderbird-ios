//
//  ReadEmailView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 10/20/25.
//

import SwiftUI

struct ReadEmailView: View {
    init(_ body: NSMutableAttributedString, _ sender: String, _ subject: String, _ sentDate: Date) {

        self.emailBody = body
        self.sender = sender
        self.subject = subject
        self.sentDate = sentDate
        emailBody.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: Color.accentColor,
            range: NSRange(location: 0, length: emailBody.length - 1)
        )
    }
    private var emailBody: NSMutableAttributedString
    private var sender: String
    private var subject: String
    private var sentDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(subject)
                .font(.title)
            SenderView(sender, sentDate)
            Text(AttributedString(emailBody))
            Spacer()
        }
        .padding()
    }

}

struct SenderView: View {
    init(_ sender: String, _ sentDate: Date) {
        self.sender = sender
        self.date = sentDate
    }
    private var sender: String
    private var date: Date
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(sender).font(.headline)
                    Text(date, style: .date)
                        .font(.caption)

                }
                Text("to me")
                    .font(.caption)
            }
            Spacer()
            HStack {
                Button(action: {
                    //Reply
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .foregroundStyle(.foreground)
                }
                Button(action: {
                    //Options
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.foreground)
                }
            }
        }
    }
}

#Preview {
    let html = """
        <html>
        <body>
        <h2>This is a test email with a bit of text</h2>
        <p>Its doing its best to model how an email might look</p>
        </body>
        </html>
        """

    let data = Data(html.utf8)
    if let attributedString = try? NSMutableAttributedString(
        data: data,
        options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil
    ) {
        ReadEmailView(
            attributedString,
            "emailSender@email.org",
            "This is the subject of the email",
            Date()
        )
    }

}
