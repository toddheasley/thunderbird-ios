//
//  OutgoingAccountSetup.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 8/18/25.
//

import SwiftUI
import Account

struct EmailAccountTypeSelection: View {
    init(_ path: Binding<NavigationPath>) {
        _path = path
    }

    @Binding var path: NavigationPath
    @Environment(LoginDetails.self) private var loginDetails: LoginDetails
    @State private var selectedJMAP: Bool = false
    @State private var selectedIMAP: Bool = false

    // MARK: View
    var body: some View {
        Form {
            Text("account_server_settings_protocol_type_label").listRowSeparator(.hidden)
            //            Toggle(isOn: $selectedJMAP) {
            //                VStack(alignment: .leading) {
            //                    Text("JMAP")
            //                    Text("JSON Meta Application Protocol")
            //                }
            //            }
            //            .simultaneousGesture(
            //                TapGesture().onEnded {
            //                    selectedIMAP = false
            //                }
            //            )
            //            .toggleStyle(FullToggleStyle())
            //            .listRowSeparator(.hidden)
            Toggle(isOn: $selectedIMAP) {
                VStack(alignment: .leading) {
                    Text("IMAP")
                    Text("Internet Mail Access Protocol")
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    selectedJMAP = false
                }
            )
            .toggleStyle(FullToggleStyle())
            .listRowSeparator(.hidden)

        }
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
        .navigationTitle("account_choose_email_type_label")
        .safeAreaInset(edge: .bottom) {
            Button(
                action: {
                    loginDetails.serverProtocol = selectedIMAP ? .imap : .jmap
                    path.append("ManualAccountSetup")

                }) {
                    Text("next_button")
                        .padding(5.5)
                        .frame(maxWidth: .infinity)
                }
                .tint(.blue)
                .padding()
                .buttonStyle(.borderedProminent)
        }

    }
}

struct FullToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark"
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .padding()
            Spacer()
            Circle()
                .stroke(
                    configuration.isOn ? .blue : .gray,
                    style: StrokeStyle(
                        lineWidth: 2
                    )
                )
                .fill(configuration.isOn ? .blue : .white)
                .padding(3)
                .frame(width: 50, height: 32)
                .overlay {
                    Image(systemName: systemImage)
                        .foregroundColor(.buttonFillOff)
                }

        }
        .onTapGesture {
            withAnimation(.spring()) {
                configuration.isOn.toggle()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(configuration.isOn ? .buttonFillOn : .buttonFillOff)
                .stroke(configuration.isOn ? .blue : .gray, lineWidth: 1)
        }
    }
}

#Preview("Outgoing Account Setup") {
    @Previewable @State var loginDetails: LoginDetails = LoginDetails()
    @Previewable @State var path: NavigationPath = NavigationPath()

    EmailAccountTypeSelection($path).environment(loginDetails)

}
