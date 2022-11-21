import SwiftUI
import VanMoofKit

// MARK: - ContentView

/// The ContentView
struct ContentView {
    
    /// The VanMoof object
    @EnvironmentObject
    private var vanMoof: VanMoof
    
}

// MARK: - View

extension ContentView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        if self.vanMoof.isAuthenticated {
            DashboardView()
        } else {
            LoginForm()
        }
    }
    
}
