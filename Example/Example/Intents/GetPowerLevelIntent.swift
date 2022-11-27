import AppIntents
import Foundation
import VanMoofKit

// MARK: - GetPowerLevelIntent

/// A GetPowerLevelIntent
struct GetPowerLevelIntent {
    
    /// The BikeAppEntity
    @Parameter(
        title: "Bike"
    )
    var bikeEntity: BikeAppEntity
    
}

// MARK: - AppIntent

extension GetPowerLevelIntent: AppIntent {
    
    /// A short, localized, human-readable string that describes the intent using a title case verb + noun.
    static let title: LocalizedStringResource = "Get power level"
    
    /// How this intent type is displayed to users.
    static let description: IntentDescription? = "Get the power level"
    
    /// Defines how this intent is summarized in relation to how its parameters are populated.
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$bikeEntity) get power level")
    }
    
    /// Performs the intent after resolving the provided parameters.
    func perform() async throws -> some ReturnsValue & ProvidesDialog & ShowsSnippetView {
        let powerLevel = try await self.bikeEntity
            .bike
            .execute { bike in
                try await bike.powerLevel
            }
        let powerLevelAppEnum: PowerLevelAppEnum = {
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
            }
        }()
        return .result(
            value: powerLevelAppEnum,
            dialog: "Power level is \(powerLevelAppEnum.localizedStringResource)",
            view: PowerLevelSnippetView(powerLevel: powerLevelAppEnum)
        )
    }
    
}
