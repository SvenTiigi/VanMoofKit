import SwiftUI
import VanMoofKit

// MARK: - ContentView

/// The ContentView
struct ContentView {
    
    /// The VanMoof authentication state.
    @State
    private var authenticationState: VanMoof.AuthenticationState?
    
    /// The App ViewModel
    @EnvironmentObject
    private var viewModel: App.ViewModel
    
}

// MARK: - View

extension ContentView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        ZStack {
            switch self.authenticationState {
            case .authenticated:
                DashboardView()
                    .onAppear(perform: self.viewModel.setup)
            case .unauthenticated:
                LoginForm()
                    .onAppear(perform: self.viewModel.reset)
            case nil:
                ProgressView()
            }
        }
        .animation(
            .default,
            value: self.authenticationState
        )
        .onReceive(
            self.viewModel.vanMoof.authenticationStatePublisher
        ) { authenticationState in
            self.authenticationState = authenticationState
        }
    }
    
}
