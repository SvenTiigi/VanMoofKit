import Foundation

// MARK: - VanMoof+Bike+Details+ModelColor

public extension VanMoof.Bike.Details {
    
    /// A VanMoof Bike Model Color
    struct ModelColor: Codable, Hashable, Sendable {
        
        // MARK: Properties
        
        /// The name of the color.
        public let name: String
        
        /// The primary color.
        public let primary: String
        
        /// The secondary color.
        public let secondary: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.ModelColor`
        /// - Parameters:
        ///   - name: The name of the color.
        ///   - primary: The primary color.
        ///   - secondary: The secondary color.
        public init(
            name: String,
            primary: String,
            secondary: String
        ) {
            self.name = name
            self.primary = primary
            self.secondary = secondary
        }
        
    }
    
}
