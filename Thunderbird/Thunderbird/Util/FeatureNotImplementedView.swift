//
//  FeatureNotImplemented.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/25/25.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct FeatureNotImplementedView: View {
    init() {
        featureName = AlertManager.shared.alertTitle ?? ""
    }
    private var featureName: String

    // MARK: View
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            ZStack {
                VStack {
                    Text(featureName).font(.title)
                    Spacer()
                    Text("feature_not_implemented")
                    Spacer()
                    Button(action: {
                        AlertManager.shared.showAlert = false
                    }) {
                        Text("OK")
                    }.buttonStyle(.borderedProminent)
                }.padding(20)
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .background(Color(white: 0.9))
            .cornerRadius(40)
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}
