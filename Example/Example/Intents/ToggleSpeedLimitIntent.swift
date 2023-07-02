import AppIntents
import SwiftUI
import VanMoofKit

// MARK: - ToggleSpeedLimitIntent

/// A ToggleSpeedLimitIntent
struct ToggleSpeedLimitIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
}

// MARK: - AppIntent

extension ToggleSpeedLimitIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Toggle speed limit"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Toggles the speed limit"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) toggle speed limit")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue & ProvidesDialog & ShowsSnippetView {
        let speedLimit = try await self.bikeEntity
            .bike
            .execute { bike in
                var speedLimit = try await bike.speedLimit
                speedLimit.toggle()
                try await bike.set(speedLimit: speedLimit)
                return speedLimit
            }
        return .result(
            value: self.bikeEntity,
            dialog: "Speed limit set to \(speedLimit.measurement.formatted())",
            view: SpeedLimitSnippetView(speedLimit: speedLimit)
        )
    }
    
}

// MARK: - VanMoof+Bike+SpeedLimit

private extension VanMoof.Bike.SpeedLimit {
    
    /// Toggle the speed limit.
    mutating func toggle() {
        switch self {
        case .europe:
            self = .unitedStates
        case .unitedStates, .japan:
            self = .europe
        }
    }
    
}
