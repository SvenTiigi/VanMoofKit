import Foundation

// MARK: - VanMoof+Bike+Details+CustomerRole

public extension VanMoof.Bike.Details {
    
    /// A VanMoof Bike Details CustomerRole
    struct CustomerRole: Hashable, Sendable {
        
        // MARK: Properties
        
        /// The value.
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.CustomerRole`
        /// - Parameter value: The value.
        public init(
            _ value: String
        ) {
            self.value = value
        }
        
    }
    
}

// MARK: - ExpressibleByStringLiteral

extension VanMoof.Bike.Details.CustomerRole: ExpressibleByStringLiteral {
    
    /// Creates a new instance of `VanMoof.Bike.Details.Permission`
    /// - Parameter value: The string literal value
    public init(
        stringLiteral value: String
    ) {
        self.init(value)
    }
    
}

// MARK: - Codable

extension VanMoof.Bike.Details.CustomerRole: Codable {
    
    /// Creates a new instance of `VanMoof.Bike.Details.Permission`
    /// - Parameter decoder: The Decoder.
    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(String.self))
    }
    
    /// Encode
    /// - Parameter encoder: The Encoder
    public func encode(
        to encoder: Encoder
    ) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
    
}

// MARK: - CustomStringConvertible

extension VanMoof.Bike.Details.CustomerRole: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        self.value
    }
    
}

// MARK: - Well-Known

public extension VanMoof.Bike.Details.CustomerRole {
    
    /// The `owner` role
    static let owner = "owner"
    
}
