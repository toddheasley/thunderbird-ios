//
//  EmailCell.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 10/17/25.
//

import SwiftUI

struct EmailCellView: View {

    // Some hard coded value for testing
    let senderText: String = "Sender"
    let headerText: String = "Read This Email"
    let bodyText: String = "This is an email about stuff with a very long line of text"
    let dateSent: Date = Date()
    let unread: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(senderText)
                    .lineLimit(1)
                    .font(.title3)
                Spacer()
                Text(dateSent, style: .date)
                    .lineLimit(1)
                    .font(.subheadline)
            }
            Text(headerText)
                .lineLimit(1)
                .font(.title3)
            Text(bodyText).lineLimit(1)
        }
    }
}

#Preview("Email Cell") {

    EmailCellView()

}
