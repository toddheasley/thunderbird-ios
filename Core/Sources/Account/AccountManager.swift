// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import AuthenticationServices

public typealias Accounts = AccountManager

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

    public func delete(_ account: Account) {
        error = nil
        do {
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
            try FileManager.default.write([], to: .accounts)
            allAccounts = []
        } catch {
            self.error = .fileManager(error)
        }
    }

    public func checkAndRenewExpirations() async throws {
        var updatedAccounts: [Account] = []
        for account in allAccounts {
            var incomingServerAuth = account.incomingServer!.authorization
            var outgoingServerAuth = account.outgoingServer!.authorization
            if account.incomingServer?.authenticationType == .oAuth2 {
                if incomingServerAuth.isExpired || outgoingServerAuth.isExpired {
                    do {
                        incomingServerAuth = try await renewExpiredToken(
                            authConfig: account.incomingServer!.authConfig!,
                            refreshToken: incomingServerAuth.refreshToken,
                            user: incomingServerAuth.user
                        )!

                        outgoingServerAuth = try await renewExpiredToken(
                            authConfig: account.outgoingServer!.authConfig!,
                            refreshToken: outgoingServerAuth.refreshToken,
                            user: outgoingServerAuth.user
                        )!
                        var account = account
                        var incomingServerInfo = account.incomingServer!
                        var outgoingServerInfo = account.outgoingServer!
                        incomingServerInfo.authorization = incomingServerAuth
                        outgoingServerInfo.authorization = outgoingServerAuth
                        incomingServerInfo.username = account.incomingServer!.username
                        outgoingServerInfo.username = account.outgoingServer!.username
                        incomingServerInfo.authConfig = account.incomingServer!.authConfig
                        outgoingServerInfo.authConfig = account.outgoingServer!.authConfig
                        account.servers = [incomingServerInfo, outgoingServerInfo]
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
                let response: TokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                let token = Token.bearer(
                    response.accessToken,
                    Date(timeIntervalSinceNow: TimeInterval(response.expiresIn))
                )
                let refreshToken = Token.refresh(response.refreshToken)
                return .oauth(user: user, token: token, refresh: refreshToken)
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
