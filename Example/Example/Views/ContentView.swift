import SwiftUI
import VanMoofKit

// MARK: - ContentView

/// The ContentView
struct ContentView {
    
    /// The App ViewModel
    @EnvironmentObject
    private var viewModel: App.ViewModel
    
}

// MARK: - View

extension ContentView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        Group {
            if self.viewModel.vanMoof.isAuthenticated {
                DashboardView()
                    .onAppear(perform: self.viewModel.setup)
            } else {
                LoginForm()
                    .onAppear(perform: self.viewModel.reset)
            }
        }
        .animation(
            .default,
            value: self.viewModel.vanMoof.isAuthenticated
        )
    }
    
}
