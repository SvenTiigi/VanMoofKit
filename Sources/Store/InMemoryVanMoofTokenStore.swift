import Foundation

// MARK: - InMemoryVanMoofTokenStore

/// An InMemory based VanMoofTokenStore
public final class InMemoryVanMoofTokenStore: VanMoofTokenStore, ObservableObject {
    
    // MARK: Static-Properties
    
    /// The shared `InMemoryVanMoofTokenStore` instance
    static let shared = InMemoryVanMoofTokenStore()
    
    // MARK: Properties
    
    /// The VanMoo Token, if available
    @Published
    public var token: VanMoof.Token?
    
    // MARK: Initializer
    
    /// Creates a new instance of `InMemoryVanMoofTokenStore`
    /// - Parameter token: The VanMoof Token. Default value `nil`
    public init(
        token: VanMoof.Token? = nil
    ) {
        self.token = token
    }
    
    // MARK: VanMoofTokenStore
    
    /// Set VanMoof Token
    /// - Parameter token: The VanMoof Token that should be set
    public func set(token: VanMoof.Token) {
        self.token = token
    }
    
    /// Remove VanMoof Token
    public func remove() {
        self.token = nil
    }
    
}
