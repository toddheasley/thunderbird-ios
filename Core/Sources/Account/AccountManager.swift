// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import AuthenticationServices

/// Globally manage shared, persistent accounts from the SwiftUI environment.
@MainActor
@Observable
public final class AccountManager {
    public private(set) var allAccounts: [Account] = []
    public var error: AccountError?

    /// Feature flag enables autoconfiguring new accounts using [JMAP](https://jmap.io), when supported by email provider.
    public var isJMAPAvailable: Bool = false

    public func account(for id: UUID) -> Account? {
        allAccounts.filter({ $0.id == id }).first
    }

    public func set(_ account: Account, at index: Int? = nil) {
        error = nil
        do {
            var accounts: [Account] = allAccounts
            let currentIndex: Int? = accounts.firstIndex { account.id == $0.id }
            if let currentIndex {
                accounts.remove(at: currentIndex)
            }
            let index: Int? = index ?? currentIndex  // New index OR current index OR nil (append to end)
            if let index, index < accounts.count {
                accounts.insert(account, at: index)  // Insert at new or current target index
            } else {
                accounts.append(account)  // Append to end of array
            }
            allAccounts = accounts
            try FileManager.default.write(accounts, to: .accounts)
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = .fileManager(error)
        }
    }

    public func hasLoggedInAccount() -> Bool {
        for account in allAccounts {
            if account.authorization.isExpired == false {
                return true
            }
        }
        return false
    }

    public func delete(_ account: Account) {
        error = nil
        do {
            account.deleteAuthorization()
            let updatedAccounts = allAccounts.filter { $0.id != account.id }
            try FileManager.default.write(updatedAccounts, to: .accounts)
            allAccounts = updatedAccounts
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = .fileManager(error)
        }
    }

    public func deleteAccounts() {
        error = nil
        do {
            URLCredentialStorage.shared.deleteAuthorizations()
            try FileManager.default.write([], to: .accounts)
            allAccounts = []
        } catch {
            self.error = .fileManager(error)
        }
    }

    public func checkAndRenewExpirations() async throws {
        var updatedAccounts: [Account] = []
        for account in allAccounts {
            var serverAuth = account.authorization
            if account.incomingServer?.authenticationType == .oAuth2 {
                if serverAuth.isExpired {
                    do {
                        serverAuth = try await renewExpiredToken(
                            authConfig: account.authConfig!,
                            refreshToken: serverAuth.refreshToken,
                            user: serverAuth.user
                        )!

                        var account = account
                        account.authorization = serverAuth
                        updatedAccounts.append(account)
                    } catch {
                        throw URLError(.unknown)
                    }
                }
            }
        }
        for account in updatedAccounts {
            self.set(account)
        }
    }

    private func renewExpiredToken(authConfig: OAuth2.Request, refreshToken: String, user: String) async throws -> Authorization? {
        let tokenRequest = try URLRequest.refreshToken(
            authConfig,
            refreshToken: refreshToken
        )
        do {
            for _ in 0..<3 {
                let (data, _) = try await URLSession.shared.data(for: tokenRequest)
                let response: RefreshTokenResponse = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
                let token = Token.bearer(
                    response.accessToken,
                    Date(timeIntervalSinceNow: TimeInterval(response.expiresIn))
                )
                return .oauth(user: user, token: token, refresh: .refresh(refreshToken))
            }
        } catch {
            throw URLError(.unknown)
        }
        return nil
    }

    public init() {
        do {
            guard try FileManager.default.fileExists(at: .accounts) else { return }
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = .fileManager(error)
        }
    }
}
