// TokenResponse.swift
// Core
//
// Created by Ashley Soucar on 8/4/26.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
//

public struct TokenResponse: Codable {
    public let access_token: String
    public let expires_in: Int
    public let refresh_token: String
}
