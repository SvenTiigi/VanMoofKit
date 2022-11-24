import AppIntents
import Foundation
import VanMoofKit

// MARK: - AppShortcuts

/// An AppShortcuts namespace enum which conforms to the `AppShortcutsProvider`
struct AppShortcuts: AppShortcutsProvider {
    
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
    
    /// The background color of the tile that Shortcuts displays for each of the app's App Shortcuts.
    static var shortcutTileColor: ShortcutTileColor {
        .yellow
    }
    
}
