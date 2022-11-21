import SwiftUI
import VanMoofKit

// MARK: - LoginForm

/// The LoginForm
struct LoginForm {
    
    @State
    private var isBusy = false
    
    @State
    private var username = String()
    
    @State
    private var password = String()
    
    /// The VanMoof object
    @EnvironmentObject
    private var vanMoof: VanMoof
    
}

private extension LoginForm {
    
    var canSubmit: Bool {
        !self.username.isEmpty && !self.password.isEmpty
    }
    
    func submit() async throws {
        self.isBusy = true
        defer {
            self.isBusy = false
        }
        try await self.vanMoof.login(
            username: self.username,
            password: self.password
        )
    }
    
}

// MARK: - View

extension LoginForm: View {
    
    /// The content and behavior of the view.
    var body: some View {
        VStack {
            TextField(
                "E-Mail",
                text: self.$username
            )
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            SecureField(
                "Password",
                text: self.$password
            )
            .textContentType(.password)
            Button {
                Task {
                    try await self.submit()
                }
            } label: {
                Text(verbatim: "Login")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!self.canSubmit)
        }
        .disabled(self.isBusy)
    }
    
}
