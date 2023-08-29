import Foundation

// MARK: - UserDefaultsVanMoofTokenStore

/// A UserDefaults based VanMoofTokenStore
public final class UserDefaultsVanMoofTokenStore: ObservableObject {
    
    // MARK: Properties
    
    /// The UserDefaults.
    public var userDefaults: UserDefaults
    
    /// The key.
    public var key: String
    
    /// The JSONDecoder.
    public var decoder: JSONDecoder
    
    /// The JSONEncoder.
    public var encoder: JSONEncoder
    
    // MARK: Initializer
    
    /// Creates a new instance of `UserDefaultsVanMoofTokenStore`
    /// - Parameters:
    ///   - userDefaults: The UserDefaults. Default value `.standard`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    public init(
        userDefaults: UserDefaults = .standard,
        key: String = VanMoof.Token.key,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.decoder = decoder
        self.encoder = encoder
    }
    
}

// MARK: - VanMoofTokenStore

extension UserDefaultsVanMoofTokenStore: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        try self.userDefaults
            .data(forKey: self.key)
            .flatMap { try self.decoder.decode(VanMoof.Token.self, from: $0) }
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        self.userDefaults
            .setValue(
                try self.encoder.encode(token),
                forKey: self.key
            )
        await MainActor.run {
            self.objectWillChange.send()
        }
    }
    
    /// Remove VanMoof token.
    public func removeToken() async throws {
        self.userDefaults.removeObject(forKey: self.key)
        await MainActor.run {
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - VanMoofTokenStore+userDefaults()

public extension VanMoofTokenStore where Self == UserDefaultsVanMoofTokenStore {
    
    /// Creates an user defaults based VanMoofTokenStore.
    /// - Parameters:
    ///   - userDefaults: The UserDefaults. Default value `.standard`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    static func userDefaults(
        userDefaults: UserDefaults = .standard,
        key: String = VanMoof.Token.key,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) -> Self {
        .init(
            userDefaults: userDefaults,
            key: key,
            decoder: decoder,
            encoder: encoder
        )
    }
    
}
