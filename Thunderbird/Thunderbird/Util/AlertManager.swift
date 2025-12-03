//
//  AlertManager.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 11/26/25.
//

import Foundation

@MainActor
@Observable class AlertManager {

    static let shared = AlertManager()
    var showAlert: Bool = false
    var alertTitle: String?
    var alertMessage: String?
    private init() {}  // Prevent creating multiple instances
}
