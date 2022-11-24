import SwiftUI
import VanMoofKit

// MARK: - LoginForm

/// The LoginForm
struct LoginForm {
    
    /// Bool value if form is busy
    @State
    private var isBusy = false
    
    /// Bool value if login failed
    @State
    private var isLoginFailed = false
    
    /// The username
    @State
    private var username = String()
    
    /// The password
    @State
    private var password = String()
    
    /// The VanMoof object
    @EnvironmentObject
    private var vanMoof: VanMoof
    
}

// MARK: - Submit

private extension LoginForm {
    
    /// Bool value if form can be submitted
    var canSubmit: Bool {
        !self.username.isEmpty && !self.password.isEmpty
    }
    
    /// Submit form
    func submit() async {
        self.isBusy = true
        do {
            try await self.vanMoof.login(
                username: self.username,
                password: self.password
            )
        } catch {
            self.isBusy = false
            self.isLoginFailed = true
            self.password.removeAll()
        }
    }
    
}

// MARK: - View

extension LoginForm: View {
    
    /// The content and behavior of the view.
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                VStack(spacing: 30) {
                    Image("BikeConnected")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask(
                            LinearGradient(
                                colors: [
                                    Color.black,
                                    Color.black,
                                    Color.black.opacity(0.95),
                                    Color.black.opacity(0.45),
                                    Color.black.opacity(0),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxHeight: 200)
                        .padding(.top, 30)
                    VStack(spacing: 3) {
                        Text(
                            verbatim: "Welcome!"
                        )
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        Text(
                            verbatim: "Enter your E-Mail address and password to establish a communication to your VanMoof S3 or X3 Bike."
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                }
                VStack(spacing: 25) {
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
                    }
                    .textFieldStyle(InputTextFieldStyle())
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                await self.submit()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                if self.isBusy {
                                    ProgressView()
                                }
                                Text(
                                    verbatim: "Login"
                                )
                                if !self.isBusy {
                                    Image(
                                        systemName: "arrow.right"
                                    )
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.accentForegroundColor)
                            .padding(.horizontal, 5)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .disabled(!self.canSubmit)
                    }
                }
                HStack(spacing: 12) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    VStack(alignment: .leading) {
                        Text(
                            verbatim: "powered by"
                        )
                        .opacity(0.8)
                        Text(
                            verbatim: "VanMoofKit"
                        )
                        .fontWeight(.semibold)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .disabled(self.isBusy)
        }
        .alert(
            "Login failed",
            isPresented: self.$isLoginFailed
        ) {
            Button {
                
            } label: {
                Text(verbatim: "Okay")
            }
        } message: {
            Text(
                verbatim: "Please check your inputs and try it again."
            )
        }
    }
    
}

// MARK: - InputTextFieldStyle

private extension LoginForm {
    
    /// An Input TextFieldStyle.
    struct InputTextFieldStyle: TextFieldStyle {
        
        func _body(
            configuration: TextField<Self._Label>
        ) -> some View {
            configuration
                .padding(
                    .init(
                        top: 15,
                        leading: 12,
                        bottom: 15,
                        trailing: 12
                    )
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .foregroundColor(.init(.systemGray6))
                )
        }
        
    }
    
}
