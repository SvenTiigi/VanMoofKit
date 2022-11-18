import Foundation

// MARK: - VanMoof+Bike

public extension VanMoof {
    
    /// A VanMoof Bike
    @dynamicMemberLookup
    final class Bike: ObservableObject {
        
        // MARK: Properties
        
        /// The details of the bike.
        public let details: Details
        
        /// The Crypto.
        let crypto: Crypto
        
        /// The BluetoothPublisher.
        lazy var bluetoothPublisher = BluetoothPublisher()
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike`
        /// - Parameters:
        ///   - details: The details of the Bike.
        public init(
            details: Details
        ) {
            self.details = details
            self.crypto = .init(key: details.key)
        }
        
    }
    
}

// MARK: - DynamicMemberLookup

public extension VanMoof.Bike {
    
    /// Dynamic member lookup on the `VanMoof.Bike.Details`
    /// - Parameter keyPath: The KeyPath.
    subscript<Value>(
        dynamicMember keyPath: KeyPath<Details, Value>
    ) -> Value {
        self.details[keyPath: keyPath]
    }
    
}

// MARK: - Identifiable

extension VanMoof.Bike: Identifiable {
    
    /// The identifier of the bike.
    public var id: Details.ID {
        self.details.id
    }
    
}

// MARK: - Codable

extension VanMoof.Bike: Codable {
    
    /// Creates a new instance of `VanMoof.Bike`
    /// - Parameter decoder: The Decoder.
    public convenience init(
        from decoder: Decoder
    ) throws {
        self.init(
            details: try .init(from: decoder)
        )
    }
    
    /// Encode
    /// - Parameter encoder: The Encoder.
    public func encode(
        to encoder: Encoder
    ) throws {
        try self.details.encode(to: encoder)
    }
    
}

// MARK: - Equatable

extension VanMoof.Bike: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (
        lhs: VanMoof.Bike,
        rhs: VanMoof.Bike
    ) -> Bool {
        lhs.details == rhs.details
    }
    
}

// MARK: - Hashable

extension VanMoof.Bike: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(self.details)
    }
    
}
