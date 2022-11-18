import Foundation

// MARK: - VanMoof+Credentials

public extension VanMoof {
    
    /// The VanMoof Credentials
    struct Credentials: Codable, Hashable {
        
        // MARK: Properties
        
        /// The username
        public let username: String
        
        /// The password
        public let password: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Credentials`
        /// - Parameters:
        ///   - username: The username
        ///   - password: The password
        public init(
            username: String,
            password: String
        ) {
            self.username = username
            self.password = password
        }
        
    }

}
