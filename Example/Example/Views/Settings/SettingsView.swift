import SwiftUI
import VanMoofKit

// MARK: - SettingsView

/// The SettingsView
struct SettingsView {
    
    /// The VanMoof User
    let user: VanMoof.User
    
    @State
    private var isLogoutConfirmationPresented = false
    
    /// The VanMoof object
    @EnvironmentObject
    private var vanMoof: VanMoof
    
}

// MARK: - View

extension SettingsView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        List {
            Section(
                header: Text(
                    verbatim: "User"
                )
            ) {
                HStack {
                    Text(
                        verbatim: "Name"
                    )
                    Spacer()
                    Text(
                        verbatim: self.user.name
                    )
                    .foregroundColor(.secondary)
                }
                HStack {
                    Text(
                        verbatim: "Phone"
                    )
                    Spacer()
                    Text(
                        verbatim: self.user.phone
                    )
                    .foregroundColor(.secondary)
                }
                HStack {
                    Text(
                        verbatim: "Country"
                    )
                    Spacer()
                    Text(
                        verbatim: Locale
                            .current
                            .localizedString(
                                forRegionCode: self.user.country
                            ) ?? self.user.country
                    )
                    .foregroundColor(.secondary)
                }
                Button(role: .destructive) {
                    self.isLogoutConfirmationPresented = true
                } label: {
                    Text(
                        verbatim: "Logout"
                    )
                }
            }
            .headerProminence(.increased)
        }
        .confirmationDialog(
            "Logout",
            isPresented: self.$isLogoutConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                Task {
                    try? await self.vanMoof.logout()
                }
            } label: {
                Text(verbatim: "Logout")
            }
            Button(role: .cancel) {
                
            } label: {
                Text(verbatim: "Cancel")
            }
        } message: {
            Text(verbatim: "Are you sure you want to logout?")
        }
        .navigationTitle("Settings")
    }
    
}
