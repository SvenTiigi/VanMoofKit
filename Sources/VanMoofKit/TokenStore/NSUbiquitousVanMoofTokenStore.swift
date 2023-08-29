import Combine
import Foundation

// MARK: - UbiquitousVanMoofTokenStore

/// A NSUbiquitousKeyValueStore based VanMoofTokenStore.
/// - Note: Please ensure to enable the iCloud Key-value storage capability in the "Signing & Capabilities" section of your Xcode project.
public final class NSUbiquitousVanMoofTokenStore: ObservableObject {
    
    // MARK: Properties
    
    /// The NSUbiquitousKeyValueStore.
    public var keyValueStore: NSUbiquitousKeyValueStore
    
    /// The key.
    public var key: String
    
    /// The JSONDecoder.
    public var decoder: JSONDecoder
    
    /// The JSONEncoder.
    public var encoder: JSONEncoder
    
    /// The did change externally cancellable.
    private var didChangeExternallyCancellable: AnyCancellable?
    
    // MARK: Initializer
    
    /// Creates a new instance of `NSUbiquitousVanMoofTokenStore`
    /// - Parameters:
    ///   - keyValueStore: The NSUbiquitousKeyValueStore. Default value `.default`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - notificationCenter: The NotificationCenter. Default value `.default`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    public init(
        keyValueStore: NSUbiquitousKeyValueStore = .default,
        key: String = VanMoof.Token.key,
        notificationCenter: NotificationCenter = .default,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.keyValueStore = keyValueStore
        self.key = key
        self.decoder = decoder
        self.encoder = encoder
        self.didChangeExternallyCancellable = notificationCenter
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
    
}

// MARK: - VanMoofTokenStore

extension NSUbiquitousVanMoofTokenStore: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        try self.keyValueStore
            .data(forKey: self.key)
            .flatMap { try self.decoder.decode(VanMoof.Token.self, from: $0) }
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        self.keyValueStore
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
        self.keyValueStore.removeObject(forKey: self.key)
        await MainActor.run {
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - VanMoofTokenStore+iCloudKeyValueStore()

public extension VanMoofTokenStore where Self == NSUbiquitousVanMoofTokenStore {
    
    /// Creates an iCloud key value store (NSUbiquitousKeyValueStore) based VanMoofTokenStore.
    /// - Note: Please ensure to enable the iCloud Key-value storage capability in the "Signing & Capabilities" section of your Xcode project.
    /// - Parameters:
    ///   - keyValueStore: The NSUbiquitousKeyValueStore. Default value `.default`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - notificationCenter: The NotificationCenter. Default value `.default`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    static func iCloudKeyValueStore(
        keyValueStore: NSUbiquitousKeyValueStore = .default,
        key: String = VanMoof.Token.key,
        notificationCenter: NotificationCenter = .default,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) -> Self {
        .init(
            keyValueStore: keyValueStore,
            key: key,
            notificationCenter: notificationCenter,
            decoder: decoder,
            encoder: encoder
        )
    }
    
}
