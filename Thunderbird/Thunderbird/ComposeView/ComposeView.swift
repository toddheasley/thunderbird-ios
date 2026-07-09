//
//  ComposeView.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 2/18/26.
//

import SwiftUI

struct ComposeView: View {
    @State private var demoHtml: String = "<h1>Hello World</h1>"
    @State private var rawText = NSAttributedString(string: "")

    var body: some View {
        ScrollView {
            ComposeHeaderView()
            ComposeBodyView()
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                }) {
                    Image(systemName: "archivebox")
                        .foregroundStyle(.foreground)
                }
            }
        }
    }
}
