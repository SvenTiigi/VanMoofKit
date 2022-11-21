import Foundation

// MARK: - UserDefaultsVanMoofTokenStore

/// A UserDefaults based VanMoofTokenStore
public struct UserDefaultsVanMoofTokenStore {
    
    // MARK: Properties
    
    /// The UserDefaults
    public var userDefaults: UserDefaults
    
    /// The UserDefaults Key
    public var userDefaultsKey: String
    
    // MARK: Initializer
    
    /// Creates a new instance of `UserDefaultsVanMoofTokenStore`
    /// - Parameters:
    ///   - userDefaults: The UserDefaults. Default value `.standard`
    ///   - userDefaultsKey: The UserDefaults Key. Default value `VanMoof.Token`
    public init(
        userDefaults: UserDefaults = .standard,
        userDefaultsKey: String = "VanMoof.Token"
    ) {
        self.userDefaults = userDefaults
        self.userDefaultsKey = userDefaultsKey
    }
    
}

// MARK: - VanMoofTokenStore

extension UserDefaultsVanMoofTokenStore: VanMoofTokenStore {
    
    /// The VanMoof Token, if available
    public var token: VanMoof.Token? {
        self.userDefaults
            .data(forKey: self.userDefaultsKey)
            .flatMap { try? JSONDecoder().decode(VanMoof.Token.self, from: $0) }
    }
    
    /// Set VanMoof Token
    /// - Parameter token: The VanMoof Token that should be set
    public func set(token: VanMoof.Token) throws {
        self.userDefaults.set(
            try JSONEncoder().encode(token),
            forKey: self.userDefaultsKey
        )
    }
    
    /// Remove VanMoof Token
    public func remove() {
        self.userDefaults.removeObject(forKey: self.userDefaultsKey)
    }
    
}
