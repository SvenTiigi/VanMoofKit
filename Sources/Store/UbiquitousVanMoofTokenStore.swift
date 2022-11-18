import Foundation

// MARK: - UbiquitousVanMoofTokenStore

/// A NSUbiquitousKeyValueStore based VanMoofTokenStore
public struct UbiquitousVanMoofTokenStore {
    
    // MARK: Properties
    
    /// The NSUbiquitousKeyValueStore
    public var ubiquitousKeyValueStore: NSUbiquitousKeyValueStore
    
    /// The NSUbiquitousKeyValueStore Key
    public var ubiquitousKeyValueStoreKey: String
    
    // MARK: Initializer
    
    /// Creates a new instance of `UbiquitousVanMoofTokenStore`
    /// - Parameters:
    ///   - ubiquitousKeyValueStore: The NSUbiquitousKeyValueStore. Default value `.default`
    ///   - ubiquitousKeyValueStoreKey: The NSUbiquitousKeyValueStore Key. Default value `VanMoof.Token`
    public init(
        ubiquitousKeyValueStore: NSUbiquitousKeyValueStore = .default,
        ubiquitousKeyValueStoreKey: String = "VanMoof.Token"
    ) {
        self.ubiquitousKeyValueStore = ubiquitousKeyValueStore
        self.ubiquitousKeyValueStoreKey = ubiquitousKeyValueStoreKey
    }
    
}

// MARK: - VanMoofTokenStore

extension UbiquitousVanMoofTokenStore: VanMoofTokenStore {
    
    /// The VanMoof Token, if available
    public var token: VanMoof.Token? {
        self.ubiquitousKeyValueStore
            .data(forKey: self.ubiquitousKeyValueStoreKey)
            .flatMap { try? JSONDecoder().decode(VanMoof.Token.self, from: $0) }
    }
    
    /// Set VanMoof Token
    /// - Parameter token: The VanMoof Token that should be set
    public func set(token: VanMoof.Token) {
        self.ubiquitousKeyValueStore.set(
            try? JSONEncoder().encode(token),
            forKey: self.ubiquitousKeyValueStoreKey
        )
    }
    
    /// Remove VanMoof Token
    public func remove() {
        self.ubiquitousKeyValueStore.removeObject(forKey: self.ubiquitousKeyValueStoreKey)
    }
    
}
