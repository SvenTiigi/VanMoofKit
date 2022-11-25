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

// MARK: - AppShortcutsProvider

extension App: AppShortcutsProvider {
    
    /// The background color of the tile that Shortcuts displays for each of the app's App Shortcuts.
    static var shortcutTileColor: ShortcutTileColor {
        .yellow
    }
    
    /// The provided AppShortcuts
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SetSpeedLimitIntent(),
            phrases: [
                "Set speed limit",
                "Configure speed limit",
                "Adjust speed limit",
                "Change speed limit"
            ]
        )
        AppShortcut(
            intent: SetPowerLevelIntent(),
            phrases: [
                "Set power level",
                "Configure power leve",
                "Adjust power level",
                "Change power level"
            ]
        )
        AppShortcut(
            intent: SetSpeedLimitAndPowerLevelIntent(),
            phrases: [
                "Set speed limit and power level",
                "Configure speed limit and power level",
                "Adjust speed limit and power level",
                "Change speed limit and power level"
            ]
        )
        AppShortcut(
            intent: GetBatteryLevelIntent(),
            phrases: [
                "Get battery level"
            ]
        )
        AppShortcut(
            intent: GetSpeedLimitIntent(),
            phrases: [
                "Get speed limit"
            ]
        )
        AppShortcut(
            intent: GetPowerLevelIntent(),
            phrases: [
                "Get power level"
            ]
        )
    }
    
}
