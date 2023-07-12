import Foundation

// MARK: - VanMoof+Bike+Details+ModelDetails

public extension VanMoof.Bike.Details {
    
    /// The VanMoof Bike Model Details
    struct ModelDetails: Hashable, Sendable {
        
        // MARK: Properties
        
        /// The color.
        public let color: String?
        
        /// The gears.
        public let gears: String
        
        /// The motor.
        public let motor: String?
        
        /// The top speed.
        public let topSpeed: String?
        
        /// The range.
        public let range: String?
        
        /// The edition.
        public let edition: String?
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.ModelDetails`
        /// - Parameters:
        ///   - color: The color.
        ///   - gears: The gears.
        ///   - motor: The motor.
        ///   - topSpeed: The top speed.
        ///   - range: The range.
        ///   - edition: The edition.
        public init(
            color: String?,
            gears: String,
            motor: String?,
            topSpeed: String?,
            range: String?,
            edition: String?
        ) {
            self.color = color
            self.gears = gears
            self.motor = motor
            self.topSpeed = topSpeed
            self.range = range
            self.edition = edition
        }
        
    }
    
}

// MARK: - Codable

extension VanMoof.Bike.Details.ModelDetails: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case color = "Colour"
        case gears = "Gears"
        case motor = "Motor"
        case topSpeed = "Top Speed"
        case range = "Range"
        case edition = "Edition"
    }
    
}
