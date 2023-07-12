import Foundation

// MARK: - VanMoof+Bike+Details+Links

public extension VanMoof.Bike.Details {
    
    /// The VanMoof Bike Details Links
    struct Links: Codable, Hashable, Sendable {
        
        // MARK: Properties
        
        /// The hash URL.
        public let hash: URL
        
        /// The thumbnail URL.
        public let thumbnail: URL
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.Links`
        /// - Parameters:
        ///   - hash: The hash URL.
        ///   - thumbnail: The thumbnail URL.
        public init(
            hash: URL,
            thumbnail: URL
        ) {
            self.hash = hash
            self.thumbnail = thumbnail
        }
        
    }
    
}
