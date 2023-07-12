import Foundation

// MARK: - VanMoof+Token

public extension VanMoof {
    
    /// A VanMoof Token
    struct Token: Hashable, Sendable {
        
        // MARK: Properties
        
        /// The access token
        public let accessToken: String
        
        /// The refresh token
        public let refreshToken: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Token`
        /// - Parameters:
        ///   - accessToken: The access token
        ///   - refreshToken: The refresh token
        public init(
            accessToken: String,
            refreshToken: String
        ) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
        }
        
    }
    
}

// MARK: - Identifiable

extension VanMoof.Token: Identifiable {
    
    /// The stable identity of the entity associated with this instance.
    public var id: String {
        [
            self.accessToken,
            self.refreshToken
        ]
        .joined(separator: ":")
    }
    
}

// MARK: - Codable

extension VanMoof.Token: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case accessToken = "token"
        case refreshToken
    }
    
}
