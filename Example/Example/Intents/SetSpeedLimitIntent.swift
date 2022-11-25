import AppIntents
import SwiftUI
import VanMoofKit

// MARK: - SetSpeedLimitIntent

/// A SetSpeedLimitIntent
struct SetSpeedLimitIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
    /// The SpeedLimitAppEnum
    @Parameter(
        title: "Speed Limit",
        default: .unitedStates
    )
    var speedLimit: SpeedLimitAppEnum
    
}

// MARK: - AppIntent

extension SetSpeedLimitIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Set speed limit"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Sets the speed limit"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) set speed limit to \(\.$speedLimit)")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue & ProvidesDialog & ShowsSnippetView {
        guard let speedLimit = VanMoof.Bike.SpeedLimit(rawValue: self.speedLimit.rawValue) else {
            throw VanMoof.Bike.Error(errorDescription: "Speed limit is not supported")
        }
        try await self.bikeEntity
            .bike
            .execute { bike in
                try await bike.set(speedLimit: speedLimit)
            }
        return .result(
            value: self.bikeEntity,
            dialog: "Speed limit set to \(speedLimit.measurement.formatted())",
            view: SpeedLimitSnippetView(speedLimit: speedLimit)
        )
    }
    
}
