//
//  ManualAccount.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 7/22/25.
//

import SwiftUI
import Account

struct ManualAccount: View {
    init(_ getStarted: Binding<Bool> = .constant(false)) {
        _getStarted = getStarted
    }
    
    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @Environment(\.openURL) private var openURL
    @Binding private var getStarted: Bool
    @State private var server: String = ""
    @State private var port: String = ""
    @State private var username: String = ""
    @State private var selectedProtocol = "JMAP"
    @State private var selectedSecurity = "SSL/TLS"
    @State private var selectedAuthentication = "Password"
    @State private var selectedCert = ""
    @State private var text: String = ""
    var protocols = ["IMAP","JMAP"]
    var securityOptions = ["None","SSL/TLS", "StartTLS"]
    var authOptions = ["Password", "Encrypted Password", "Client Certificate", "OAuth 2.0"]
    
    // MARK: View
    var body: some View {
        Form {
            Picker("account_server_settings_protocol_type_label", selection: $selectedProtocol){
                ForEach(protocols, id: \.self) { prot in
                    Text(prot)
                }
            }
            .pickerStyle(.menu)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Picker("account_server_settings_security_label", selection: $selectedSecurity){
                ForEach(securityOptions, id: \.self) { sec in
                    Text(sec)
                }
            }
            .pickerStyle(.menu)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Picker("account_server_settings_authentication_label", selection: $selectedAuthentication){
                ForEach(authOptions, id: \.self) { auth in
                    Text(auth)
                }
            }
            .pickerStyle(.menu)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading, spacing: 10.0) {
                Text("account_server_settings_server_label")
                TextField("account_server_settings_server_label", text: $server)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading, spacing: 10.0) {
                Text("account_server_settings_port_label")
                TextField("account_server_settings_port_label", text: $port)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading, spacing: 10.0) {
                Text("account_server_settings_username_label")
                TextField("account_server_settings_username_label", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Fastmail JMAP Preview")
                    .font(.headline)
                TextField("Fastmail API token", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                Text("Thunderbird can read email from a Fastmail account using a self-issued API token.")
                    .multilineTextAlignment(.leading)
                Link(destination: .help) {
                    Text("Generate a token")
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            if selectedProtocol == "IMAP" {
                Text("configuration_IMAP_not_supported")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .opacity(0.75)
                    .padding()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            Button(action: {
                jmap.token = text
            }) {
                Text("account_oauth_sign_in_button")
                    .padding(5.5)
            }
            .listRowBackground(Color.clear)
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(selectedProtocol == "IMAP")
        }
        .scrollContentBackground(.hidden)
        .background {
            Background()
        }
    }
}

#Preview("Manual Account Setup") {
    @Previewable @State var getStarted: Bool = false
    @Previewable @State var jmap: JMAPObject = JMAPObject()
    
    ManualAccount($getStarted)
        .environment(jmap)
        .sheet(isPresented: $getStarted) {
            EmptyView()
                .presentationDragIndicator(.visible)
        }
}

private struct Background: View {
    
    // MARK: View
    var body: some View {
        GeometryReader { proxy in
            Image.background
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .opacity(proxy.size.width > 444.0 ? 0.0 : 1.0)
        }
        .ignoresSafeArea()
    }
}

private extension Image {
    static var background: Self { Self("Welcome/Background") }
    static var logo: Self { Self("Welcome/Logo") }
}
