import AppIntents
import Foundation
import VanMoofKit

// MARK: - GetBatteryLevelIntent

/// A GetBatteryLevelIntent
struct GetBatteryLevelIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
}

// MARK: - AppIntent

extension GetBatteryLevelIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Get battery level"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Get the battery level"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) get battery level")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue & ProvidesDialog & ShowsSnippetView {
        let batteryLevel = try await self.bikeEntity
            .bike
            .execute { bike in
                try await bike.batteryLevel
            }
        return .result(
            value: batteryLevel,
            dialog: "Battery level is \(batteryLevel) %",
            view: BatteryLevelSnippetView(batteryLevel: batteryLevel)
        )
    }
    
}
