// UtilFunctions.swift
// Thunderbird
//
// Created by Ashley Soucar on 7/6/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

import Foundation
import SwiftUI

func createAvatarText(displayName: String) -> String {
    let splitName = displayName.split(separator: " ")
    if splitName.count >= 2 {
        let letter = "\(splitName[0].capitalized.first!)\(splitName[1].capitalized.first!)"
        return letter
    } else {
        return String(splitName[0].capitalized.first!)
    }
}

func randomizeAvatarColor() -> Color {
    let userColors: [Color] = [.userRed, .userOrange, .userYellow, .userGreen, .userBlue, .userPink, .userPurple]
    return userColors.randomElement()!
}
