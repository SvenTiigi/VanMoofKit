import AppIntents
import Foundation

// MARK: - PowerLevelAppEnum

/// A PowerLevel AppEnum
enum PowerLevelAppEnum: Int {
    /// Off
    case off
    /// Level 1
    case one
    /// Level 2
    case two
    /// Level 3
    case three
    /// Level 4
    case four
}

// MARK: - SpeedLimitAppEnum+AppEnum

extension PowerLevelAppEnum: AppEnum {
    
    /// A short, localized, human-readable name for the type.
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Power level",
        numericFormat: "\(placeholder: .int) power levels"
    )
    
    /// A dictionary that maps each value to the visual elements that reperesent it.
    public static let caseDisplayRepresentations: [Self : DisplayRepresentation] = [
        .off: .init(
            title: "Off"
        ),
        .one: .init(
            title: "Level 1"
        ),
        .two: .init(
            title: "Level 2"
        ),
        .three: .init(
            title: "Level 3"
        ),
        .four: .init(
            title: "Level 4"
        )
    ]
    
}
