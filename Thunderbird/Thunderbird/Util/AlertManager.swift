//
//  AlertManager.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/26/25.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

@MainActor
@Observable class AlertManager {

    static let shared = AlertManager()
    var showAlert: Bool = false
    var alertTitle: String?
    var alertMessage: String?
    private init() {}  // Prevent creating multiple instances
}
