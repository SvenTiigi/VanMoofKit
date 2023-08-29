import Combine
import Foundation

// MARK: - ObservableObjectVanMoofTokenMediator

/// An observable object VanMoofTokenStore mediator.
final class ObservableObjectVanMoofTokenMediator: ObservableObject {
    
    // MARK: Properties
    
    /// The VanMoofTokenStore.
    private let vanMoofTokenStore: VanMoofTokenStore
    
    /// The object will change VanMoofTokenStore cancellable.
    private var objectWillChangeVanMoofTokenStoreCancellable: AnyCancellable?
    
    // MARK: Initializer
    
    /// Creates a new instance of `ObservableObjectVanMoofTokenMediator`
    /// - Parameters:
    ///   - vanMoofTokenStore: The VanMoofTokenStore.
    init(
        _ vanMoofTokenStore: VanMoofTokenStore
    ) {
        self.vanMoofTokenStore = vanMoofTokenStore
        // Check if VanMoofTokenStore conforms to the ObservableObject protocol
        if let observableObject = self.vanMoofTokenStore as? any ObservableObject,
           case let objectWillChangePublisher = observableObject.objectWillChange as any Publisher,
           let observableObjectPublisher = objectWillChangePublisher as? ObservableObjectPublisher {
            // Subscribe to object will change on VanMoofTokenStore
            self.objectWillChangeVanMoofTokenStoreCancellable = observableObjectPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    // Redirect changes
                    self?.objectWillChange.send()
                }
        }
    }
    
}

// MARK: - VanMoofTokenStore

extension ObservableObjectVanMoofTokenMediator: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        try await self.vanMoofTokenStore.token()
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        try await self.vanMoofTokenStore.save(token: token)
        await self.sendObjectWillChangeIfNeeded()
    }
    
    /// Remove VanMoof token.
    public func removeToken() async throws {
        try await self.vanMoofTokenStore.removeToken()
        await self.sendObjectWillChangeIfNeeded()
    }
    
}

// MARK: - Send object will change if needed

private extension ObservableObjectVanMoofTokenMediator {
    
    /// Send object will change, if needed
    func sendObjectWillChangeIfNeeded() async {
        // Verify an object will change cancellable is unavailable
        guard self.objectWillChangeVanMoofTokenStoreCancellable == nil else {
            // Otherwise return out of function
            // As there is no need to send changes
            return
        }
        // Run on main actor
        await MainActor.run {
            // Send changes
            self.objectWillChange.send()
        }
    }
    
}
