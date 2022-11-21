import SwiftUI
import VanMoofKit

// MARK: - App

/// The App
@main
struct App {
    
    /// The VanMoof object
    let vanMoof = VanMoof(
        // Specify in which way the VanMoof Token should be stored.
        // Available implementations:
        //  - UserDefaultsVanMoofTokenStore (UserDefaults)
        //  - UbiquitousVanMoofTokenStore (NSUbiquitousKeyValueStore)
        //  - InMemoryVanMoofTokenStore (InMemory)
        tokenStore: UserDefaultsVanMoofTokenStore()
    )
    
}

// MARK: - SwiftUI.App

extension App: SwiftUI.App {
    
    /// The content and behavior of the app.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.vanMoof)
        }
    }
    
}
