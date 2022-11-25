import AppIntents
import SwiftUI
import VanMoofKit

// MARK: - SetSpeedLimitAndPowerLevelIntent

/// A SetSpeedLimitAndPowerLevelIntent
struct SetSpeedLimitAndPowerLevelIntent {
    
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
    
    /// The SpeedLimitAppEnum
    @Parameter(
        title: "Power level",
        default: .four
    )
    var powerLevel: PowerLevelAppEnum
    
}

// MARK: - AppIntent

extension SetSpeedLimitAndPowerLevelIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Set speed limit and power level"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Sets the speed limit and power level"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) set speed limit to \(\.$speedLimit) and power level to \(\.$powerLevel)")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue & ProvidesDialog & ShowsSnippetView {
        guard let speedLimit = VanMoof.Bike.SpeedLimit(rawValue: self.speedLimit.rawValue) else {
            throw VanMoof.Bike.Error(errorDescription: "Speed limit is not supported")
        }
        guard let powerLevel = VanMoof.Bike.PowerLevel(rawValue: self.powerLevel.rawValue) else {
            throw VanMoof.Bike.Error(errorDescription: "Power level is not supported")
        }
        try await self.bikeEntity
            .bike
            .execute { bike in
                async let speedLimit: Void = bike.set(speedLimit: speedLimit)
                async let powerLevel: Void = bike.set(powerLevel: powerLevel)
                _ = try await [speedLimit, powerLevel]
            }
        return .result(
            value: self.bikeEntity,
            dialog: "Speed limit set to \(speedLimit.measurement.formatted()) and power level to \(self.powerLevel.localizedStringResource)"
        ) {
            HStack {
                SpeedLimitSnippetView(speedLimit: speedLimit)
                Divider()
                PowerLevelSnippetView(
                    powerLevel: {
                        switch powerLevel {
                        case .off:
                            return .off
                        case .one:
                            return .one
                        case .two:
                            return .two
                        case .three:
                            return .three
                        case .four:
                            return .four
                        case .maximum:
                            return .maximum
                        }
                    }()
                )
            }
        }
    }
    
}
