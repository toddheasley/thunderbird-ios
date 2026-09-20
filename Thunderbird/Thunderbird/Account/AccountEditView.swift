// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountEditView: View {
    init(
        _ account: Binding<Account>,
        path: Binding<NavigationPath> = .constant(NavigationPath())
    ) {
        _account = account
        _path = path
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Binding private var account: Account
    @Binding private var path: NavigationPath

    // MARK: View
    var body: some View {
        ScrollView {
            ContentUnavailableView("EDIT", systemImage: "burst.fill")
                .navigationTitle("edit_account_header")
                .onAppear {
                    print(account.emailAddress?.description ?? "nil")
                }
        }
    }
}

#Preview("Account Edit View") {
    @Previewable @State var accountManager: AccountManager = AccountManager()
    @Previewable @State var account: Account = Account("Pat Example <example@gmaail.com>")
    @Previewable @State var path: NavigationPath = NavigationPath()

    NavigationStack(path: $path) {
        AccountEditView($account, path: $path)
            .environment(accountManager)
    }
}

struct ConnectionSecurityView: View {
    init(_ connectionSecurity: Binding<Server.ConnectionSecurity>) {
        _connectionSecurity = connectionSecurity
    }

    @Binding private var connectionSecurity: Server.ConnectionSecurity

    // MARK: View
    var body: some View {
        Picker("account_server_settings_security_label", selection: $connectionSecurity) {
            ForEach(Server.ConnectionSecurity.allCases, id: \.self) {
                Text($0.description.capitalized(.sentence))
            }
        }
        .formInput("account_server_settings_security_label", layout: .horizontal)
    }
}

#Preview("Connection Security View") {
    @Previewable @State var connectionSecurity: Server.ConnectionSecurity = .tls

    ConnectionSecurityView($connectionSecurity)
        .onChange(of: connectionSecurity, initial: true) {
            print(connectionSecurity)
        }
        .padding()
}

/*
struct _AccountEditView: View {
    var account: Account {
        Account(
            name: name,
            identities: [
                EmailAddress(emailAddress)
            ],
            servers: servers,
            id: id
        )
    }

    init(_ account: Account = Account(name: "")) {
        let jmapServer: Server = account.server(.jmap) ?? Server(.jmap)
        let imapServer: Server = account.server(.imap) ?? Server(.imap)
        let smtpServer: Server = account.server(.smtp) ?? Server(.smtp)
        name = account.name
        emailAddress = account.identities.first?.value ?? ""
        emailProtocol = account.emailProtocol
        switch account.emailProtocol {
        case .imap:
            authenticationType = imapServer.authenticationType
        case .jmap:
            authenticationType = jmapServer.authenticationType
        }
        authorization = account.authorization
        self.jmapServer = jmapServer
        self.imapServer = imapServer
        self.smtpServer = smtpServer
        id = account.id
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isPresented: Bool = false
    @State private var name: String
    @State private var emailAddress: String
    @State private var emailProtocol: Account.EmailProtocol
    @State private var authenticationType: AuthenticationType
    @State private var authorization: Authorization
    @State private var jmapServer: Server
    @State private var imapServer: Server
    @State private var smtpServer: Server
    private let id: UUID

    private var isAdding: Bool { accountManager.account(for: id) == nil }

    private var servers: [Server] {
        switch emailProtocol {
        case .imap:
            [
                imapServer,
                smtpServer
            ]
        case .jmap:
            [
                jmapServer
            ]
        }
    }

    // MARK: View
    var body: some View {
        VStack {
            VStack(spacing: 10.0) {
                HStack {
                    Text("Display Name")
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top)
                TextField("\(emailAddress)", text: $name)
                    .autoFormattingDisabled()
                HStack {
                    Text("Email Address")
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top)
                TextField("name@example.com", text: $emailAddress)
                    .autoFormattingDisabled()
                    #if os(iOS)
                .keyboardType(.emailAddress)
                    #endif
                AccountAuthorizationView(emailAddress, $authenticationType, authorization: $authorization)
                    .onChange(of: authenticationType, initial: true) {
                        jmapServer.authenticationType = authenticationType
                        imapServer.authenticationType = authenticationType
                        smtpServer.authenticationType = authenticationType
                    }
            }
            .padding()
            Divider()
            Picker("Email Protocol", selection: $emailProtocol) {
                ForEach(Account.EmailProtocol.allCases, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding()
            ScrollView {
                VStack {
                    switch emailProtocol {
                    case .imap:
                        ServerEditView($imapServer)
                        Divider()
                            .padding(.vertical)
                        ServerEditView($smtpServer)
                    case .jmap:
                        ServerEditView($jmapServer)
                    }
                }
                .padding()
                .containerRelativeFrame(.horizontal)
            }
        }
        .navigationTitle(isAdding ? "Add Account" : "Edit Account")
        .toolbar {
            Button(action: {
                isPresented = true
            }) {
                Label("Test", systemImage: "stethoscope")
            }
            Button(action: {
                accountManager.set(account)
            }) {
                Label("Save", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $isPresented) {
            ContentUnavailableView("TBD", systemImage: "burst.fill")
                // AccountTestView(account)
                .presentationDragIndicator(.visible)
        }
        .error()
    }
} */

struct ServerEditView: View {
    init(_ server: Binding<Server>) {
        _server = server
    }

    @Binding private var server: Server

    // MARK: View
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                Text("\(server.serverProtocol.description) Server")
                Spacer()
            }
            .font(.headline)
            HStack {
                Text("Hostname")
                Spacer()
                Text("Port")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            HStack {
                TextField(server.titleKey, text: $server.hostname)
                    .autoFormattingDisabled()
                Spacer()
                TextField("\(server.serverProtocol.defaultPort)", value: $server.port, format: .number)
                    .multilineTextAlignment(.trailing)
                    .autoFormattingDisabled()
                    .frame(maxWidth: 64.0)
            }
            ConnectionSecurityView($server.connectionSecurity)
        }
    }
}

#Preview("ServerEditView") {
    @Previewable @State var server: Server = Server(.imap, connectionSecurity: .tls, hostname: "imap.example.com")

    ServerEditView($server)
        .onChange(of: server, initial: true) {
            print(server)
        }
        .padding()
}

private extension Server {
    var titleKey: String {
        "\(serverProtocol.description.lowercased()).example.com"
    }
}

struct AccountAuthorizationView: View {
    let emailAddress: String

    init(_ emailAddress: String, _ authenticationType: Binding<AuthenticationType>, authorization: Binding<Authorization>) {
        self.emailAddress = emailAddress
        _authenticationType = authenticationType
        _authorization = authorization
    }
    @Binding private var authenticationType: AuthenticationType
    @Binding private var authorization: Authorization
    @State private var password: String = ""

    // MARK: View
    var body: some View {
        VStack {
            AuthenticationTypeView($authenticationType)
            switch authenticationType {
            case .password:
                PasswordField(text: $password)
                    .onChange(of: password) {
                        authorization = .basic(user: emailAddress, password: password)
                    }
                    .padding(.vertical)
            case .oAuth2:
                Label("OAuth2 not available", systemImage: "lock.slash")
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 1.0)
                    .padding(.vertical)
            case .none:
                EmptyView()
            }
        }
        .onChange(of: authorization, initial: true) {
            switch authorization {
            case .basic(_, let password):
                self.password = password
            default:
                break
            }
        }
    }
}

#Preview("AuthorizationView") {
    @Previewable @State var authenticationType: AuthenticationType = .password
    @Previewable @State var authorization: Authorization = .basic(user: "user@example.com", password: "fake-appp-pass-word")

    AccountAuthorizationView("user@example.com", $authenticationType, authorization: $authorization)
        .onChange(of: authenticationType, initial: true) {
            print(authenticationType)
        }
        .onChange(of: authorization, initial: true) {
            print(authorization)
        }
        .padding()
}
