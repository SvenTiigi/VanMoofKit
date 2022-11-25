import AppIntents
import Foundation
import VanMoofKit

// MARK: - SetPowerLevelIntent

/// A SetPowerLevelIntent
struct SetPowerLevelIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
    /// The PowerLevelAppEnum
    @Parameter(
        title: "Power level",
        default: .four
    )
    var powerLevel: PowerLevelAppEnum
    
}

// MARK: - AppIntent

extension SetPowerLevelIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Set power level"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Sets the power level"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) set power level to \(\.$powerLevel)")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ProvidesDialog & ReturnsValue {
        guard let powerLevel = VanMoof.Bike.PowerLevel(rawValue: self.powerLevel.rawValue) else {
            throw VanMoof.Bike.Error(errorDescription: "Power level is not supported")
        }
        try await self.bikeEntity
            .bike
            .execute { bike in
                try await bike.set(powerLevel: powerLevel)
            }
        return .result(
            value: self.bikeEntity,
            dialog: "Power level set to \("\(powerLevel)")"
        )
    }
    
}
