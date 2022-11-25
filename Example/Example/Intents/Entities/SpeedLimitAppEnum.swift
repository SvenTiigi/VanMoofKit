import AppIntents
import Foundation
import VanMoofKit

// MARK: - SpeedLimitAppEnum

/// A SpeedLimit AppEnum
enum SpeedLimitAppEnum: Int {
    /// Europe (EU) | `25 km/h`
    case europe
    /// United States (US) | `32 km/h`
    case unitedStates
    /// Japan (JP) | `24 km/h`
    case japan
}

// MARK: - SpeedLimitAppEnum+AppEnum

extension SpeedLimitAppEnum: AppEnum {
    
    /// A short, localized, human-readable name for the type.
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Speed limit",
        numericFormat: "\(placeholder: .int) speed limits"
    )
    
    /// A dictionary that maps each value to the visual elements that reperesent it.
    public static let caseDisplayRepresentations: [Self : DisplayRepresentation] = [
        .europe: .init(
            title: "Europe (25 km/h)"
        ),
        .unitedStates: .init(
            title: "United States (32 km/h)"
        ),
        .japan: .init(
            title: "Japan (24 km/h)"
        )
    ]
    
}
