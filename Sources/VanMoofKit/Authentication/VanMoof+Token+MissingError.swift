import Foundation

// MARK: - VanMoof+Token+MissingError

public extension VanMoof.Token {
    
    /// A VanMoof Token Missing Error
    struct MissingError: Swift.Error, Codable, Hashable, Sendable {
        
        /// Creates a new instance of `VanMoof.Token.MissingError`
        public init() {}
        
    }
    
}
