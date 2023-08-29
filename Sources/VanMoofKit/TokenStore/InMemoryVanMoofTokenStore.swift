import Foundation

// MARK: - InMemoryVanMoofTokenStore

/// An InMemory based VanMoofTokenStore
public final class InMemoryVanMoofTokenStore: ObservableObject {
    
    // MARK: Static-Properties
    
    /// The shared `InMemoryVanMoofTokenStore` instance
    public static let shared = InMemoryVanMoofTokenStore()
    
    // MARK: Properties
    
    /// The VanMoof token, if available
    @Published
    public var token: VanMoof.Token?
    
    // MARK: Initializer
    
    /// Creates a new instance of `InMemoryVanMoofTokenStore`
    /// - Parameter token: The VanMoof token. Default value `nil`
    public init(
        token: VanMoof.Token? = nil
    ) {
        self.token = token
    }
    
}

// MARK: - VanMoofTokenStore

extension InMemoryVanMoofTokenStore: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        await MainActor.run {
            self.token
        }
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        await MainActor.run {
            self.token = token
        }
    }
    
    /// Remove VanMoof token.
    public func removeToken() async throws {
        await MainActor.run {
            self.token = nil
        }
    }
    
}

// MARK: - VanMoofTokenStore+inMemory()

public extension VanMoofTokenStore where Self == InMemoryVanMoofTokenStore {
    
    /// Creates an in memory based VanMoofTokenStore.
    /// - Parameter token: The VanMoof token. Default value `nil`
    static func inMemory(
        token: VanMoof.Token? = nil
    ) -> Self {
        .init(token: token)
    }
    
}
