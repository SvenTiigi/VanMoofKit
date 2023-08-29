import Foundation
import LocalAuthentication

// MARK: - LARightVanMoofTokenStore

/// An local authentication based VanMoofTokenStore.
@available(iOS 16.0, macOS 13.0, *)
public final class LARightVanMoofTokenStore: ObservableObject {
    
    // MARK: Typealias
    
    /// A closure providing the local authentication right for a given VanMoof token.
    public typealias RightProvider = (VanMoof.Token) -> LARight
    
    // MARK: Properties
    
    /// The LARightStore.
    public var store: LARightStore
    
    /// The key.
    public var key: String
    
    /// The JSONDecoder.
    public var decoder: JSONDecoder
    
    /// The JSONEncoder.
    public var encoder: JSONEncoder
    
    /// The localized authorization reason.
    public var localizedAuthorizationReason: String
    
    /// A closure providing the local authentication right for a given VanMoof token.
    public var rightProvider: RightProvider
    
    /// The previously authorized right.
    @Published
    private var authorizedRight: LAPersistedRight?
    
    // MARK: Initializer
    
    /// Creates a new instance of `LARightAuthSessionIDStore`
    /// - Parameters:
    ///   - store: The LARightStore. Default value `.shared`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    ///   - localizedAuthorizationReason: The localized authorization reason.
    ///   - rightProvider: A closure providing the local authentication right for a given VanMoof token. Default value `.init()`
    public init(
        store: LARightStore = .shared,
        key: String = VanMoof.Token.key,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init(),
        localizedAuthorizationReason: String,
        rightProvider: @escaping RightProvider =  { _ in .init() }
    ) {
        self.store = store
        self.key = key
        self.decoder = decoder
        self.encoder = encoder
        self.localizedAuthorizationReason = localizedAuthorizationReason
        self.rightProvider = rightProvider
    }
    
}

// MARK: - AuthSessionIDStore

@available(iOS 16.0, macOS 13.0, *)
extension LARightVanMoofTokenStore: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        guard let authorizedRight: LAPersistedRight = try await {
            if let authorizedRight = await MainActor.run(body: { self.authorizedRight }) {
                return authorizedRight
            }
            guard let right = try? await self.store.right(forIdentifier: self.key) else {
                return nil
            }
            try await right.authorize(
                localizedReason: self.localizedAuthorizationReason
            )
            await MainActor.run {
                self.authorizedRight = right
            }
            return right
        }() else {
            return nil
        }
        return try await self.decoder
            .decode(
                VanMoof.Token.self,
                from: authorizedRight.secret.rawData
            )
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        try await self.store.saveRight(
            self.rightProvider(token),
            identifier: self.key,
            secret: self.encoder.encode(token)
        )
        _ = await MainActor.run {
            self.authorizedRight = nil
        }
    }
    
    /// Remove VanMoof token.
    public func removeToken() async throws {
        try await self.store.removeRight(
            forIdentifier: self.key
        )
        _ = await MainActor.run {
            self.authorizedRight = nil
        }
    }
    
}

// MARK: - VanMoofTokenStore+localAuthentication()

@available(iOS 16.0, macOS 13.0, *)
public extension VanMoofTokenStore where Self == LARightVanMoofTokenStore {
    
    /// Creates a local authentication based VanMoofTokenStore.
    /// - Parameters:
    ///   - store: The LARightStore. Default value `.shared`
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    ///   - localizedAuthorizationReason: The localized authorization reason.
    ///   - rightProvider: A closure providing the local authentication right for a given VanMoof token. Default value `.init()`
    static func localAuthentication(
        store: LARightStore = .shared,
        key: String = VanMoof.Token.key,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init(),
        localizedAuthorizationReason: String,
        rightProvider: @escaping LARightVanMoofTokenStore.RightProvider =  { _ in .init() }
    ) -> Self {
        .init(
            store: store,
            key: key,
            decoder: decoder,
            encoder: encoder,
            localizedAuthorizationReason: localizedAuthorizationReason,
            rightProvider: rightProvider
        )
    }
    
}
