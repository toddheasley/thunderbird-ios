import Core
import SwiftUI

struct AccountEditView: View {
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
            authorization = imapServer.authorization
        case .jmap:
            authenticationType = jmapServer.authenticationType
            authorization = jmapServer.authorization
        }
        self.jmapServer = jmapServer
        self.imapServer = imapServer
        self.smtpServer = smtpServer
        id = account.id
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Environment(\.dismiss) private var dismiss
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
                HStack {
                    Text("Email Address")
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top)
                TextField("name@example.com", text: $emailAddress)
                AuthorizationView(emailAddress, $authenticationType, authorization: $authorization)
                    .onChange(of: authenticationType, initial: true) {
                        jmapServer.authenticationType = authenticationType
                        imapServer.authenticationType = authenticationType
                        smtpServer.authenticationType = authenticationType
                    }
                    .onChange(of: authorization, initial: true) {
                        jmapServer.authorization = authorization
                        imapServer.authorization = authorization
                        smtpServer.authorization = authorization
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
        #if os(iOS)
        .navigationBarTitleDisplayMode(isAdding ? .inline : .automatic)
        #endif
        .navigationTitle(isAdding ? "Add Account" : "Edit Account")
        .toolbar {
            Button(action: {
                isPresented = true
            }) {
                Label("Test", systemImage: "stethoscope")
            }
            Button(action: {
                accountManager.set(account)
                dismiss()
            }) {
                Label("Save", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $isPresented) {
            AccountTestView(account)
                .presentationDragIndicator(.visible)
        }
        .error()
    }
}

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
                Spacer()
                TextField("\(server.serverProtocol.defaultPort)", value: $server.port, format: .number)
                    .multilineTextAlignment(.trailing)
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

struct ConnectionSecurityView: View {
    init(_ connectionSecurity: Binding<Server.ConnectionSecurity>) {
        _connectionSecurity = connectionSecurity
    }

    @Binding private var connectionSecurity: Server.ConnectionSecurity

    // MARK: View
    var body: some View {
        VStack {
            HStack {
                Text("Connection Security")
                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            Picker("Connection Security", selection: $connectionSecurity) {
                ForEach(Server.ConnectionSecurity.allCases, id: \.self) {
                    Text($0.description.uppercased())
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .padding(.vertical)
    }
}

#Preview("ConnectionSecurityView") {
    @Previewable @State var connectionSecurity: Server.ConnectionSecurity = .tls

    ConnectionSecurityView($connectionSecurity)
        .onChange(of: connectionSecurity, initial: true) {
            print(connectionSecurity)
        }
        .padding()
}

struct AuthenticationTypeView: View {
    init(_ authenticationType: Binding<AuthenticationType>) {
        _authenticationType = authenticationType
    }

    @Binding private var authenticationType: AuthenticationType

    // MARK: View
    var body: some View {
        VStack {
            HStack {
                Text("Authentication")
                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            Picker("Authentication", selection: $authenticationType) {
                ForEach(AuthenticationType.allCases, id: \.self) {
                    Text($0.description.uppercased())
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .padding(.vertical)
    }
}

#Preview("AuthenticationTypeView") {
    @Previewable @State var authenticationType: AuthenticationType = .oAuth2

    AuthenticationTypeView($authenticationType)
        .onChange(of: authenticationType, initial: true) {
            print(authenticationType)
        }
        .padding()
}

struct AuthorizationView: View {
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

    AuthorizationView("user@example.com", $authenticationType, authorization: $authorization)
        .onChange(of: authenticationType, initial: true) {
            print(authenticationType)
        }
        .onChange(of: authorization, initial: true) {
            print(authorization)
        }
        .padding()
}

struct PasswordField: View {
    let titleKey: LocalizedStringKey

    init(_ titleKey: LocalizedStringKey = "Password", text: Binding<String>, isSecure: Bool = true) {
        self.titleKey = titleKey
        self.isSecure = isSecure
        _text = text
    }

    @Binding private var text: String
    @State private var isSecure: Bool

    // MARK: View
    var body: some View {
        ZStack(alignment: .trailing) {
            SecureField(titleKey, text: $text)
                .monospaced()
                .opacity(isSecure ? 1.0 : 0.0)
            TextField(titleKey, text: $text)
                .monospaced()
                .opacity(isSecure ? 0.0 : 1.0)
            Button(action: {
                isSecure.toggle()
            }) {
                Label("Toggle", systemImage: isSecure ? "eye.slash" : "eye.fill")
                    .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview("PasswordField") {
    @Previewable @State var text: String = "fake-appp-pass-word"

    PasswordField(text: $text)
        .onChange(of: text, initial: true) {
            print(text)
        }
        .padding()
}
