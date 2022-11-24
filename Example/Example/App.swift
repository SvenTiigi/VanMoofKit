import AppIntents
import SwiftUI
import VanMoofKit

// MARK: - App

/// The App
@main
struct App {}

// MARK: - SwiftUI.App

extension App: SwiftUI.App {
    
    /// The content and behavior of the app.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel.default)
                .environmentObject(ViewModel.default.vanMoof)
        }
    }
    
}
