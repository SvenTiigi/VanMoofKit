import AppIntents
import Foundation
import VanMoofKit

// MARK: - GetSpeedLimitIntent

/// A GetSpeedLimitIntent
struct GetSpeedLimitIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
}

// MARK: - AppIntent

extension GetSpeedLimitIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Get speed limit"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Get the speed limit"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) get speed limit")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue<SpeedLimitAppEnum> & ProvidesDialog & ShowsSnippetView {
        let speedLimit = try await self.bikeEntity
            .bike
            .execute { bike in
                try await bike.speedLimit
            }
        return .result(
            value: {
                switch speedLimit {
                case .europe:
                    return .europe
                case .unitedStates:
                    return .unitedStates
                case .japan:
                    return .japan
                }
            }(),
            dialog: "Speed limit is set to \(speedLimit.measurement.formatted())",
            view: SpeedLimitSnippetView(speedLimit: speedLimit)
        )
    }
    
}
