import Core
import SwiftUI

struct AccountTestView: View {
    let account: Account

    init(_ account: Account) {
        self.account = account
    }

    @State private var results: [TestResult] = []
    @State private var isTesting: Bool = false

    // MARK: View
    var body: some View {
        VStack {
            ContentUnavailableView("\(account.name)", systemImage: "stethoscope")
            ForEach(results) { result in
                HStack {
                    Text(result.description)
                    Spacer()
                    Image(systemName: result.isFailure ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .foregroundStyle(result.isFailure ? .red : .green)
                }
            }
            HStack {
                Text("Testing…")
                Spacer()
                ProgressView()
            }
            .opacity(isTesting ? 1.0 : 0.0)
        }
        .padding()
        .task {
            try? await Task.sleep(for: .seconds(1))
            isTesting = true
            for await result in account.test(sleep: .milliseconds(200)) {
                results.append(result)
            }
            isTesting = false
        }
    }
}

#Preview {
    @Previewable @State var account: Account = Account(name: "")

    AccountTestView(account)
}
