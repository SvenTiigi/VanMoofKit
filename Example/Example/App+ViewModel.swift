import Combine
import SwiftUI
import VanMoofKit

// MARK: - App+ViewModel

extension App {
    
    /// The App ViewModel
    final class ViewModel: ObservableObject {
        
        // MARK: Static-Properties
        
        /// The default `ViewModel` instance
        static let `default` = ViewModel()
        
        // MARK: Properties
        
        /// The VanMoof ObjectWillChange Cancellable
        private var vanMoofObjectWillChangeCancellable: AnyCancellable?
        
        /// The VanMoof instance
        private(set) lazy var vanMoof: VanMoof = {
            let vanMoof = VanMoof(
                tokenStore: UserDefaultsVanMoofTokenStore()
            )
            self.vanMoofObjectWillChangeCancellable = vanMoof
                .objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
            return vanMoof
        }()
        
        /// The User
        @Published
        private(set) var user: Result<VanMoof.User, Error>?
        
        /// The selected Bike Identifier
        @Published
        var selectedBikeId: VanMoof.Bike.ID?
        
    }
    
}

// MARK: - App+ViewModel+setup

extension App.ViewModel {
    
    /// Setup ViewModel
    func setup() {
        // Verify user has not been loaded
        guard self.user == nil else {
            // Otherwise setup has already been performed
            return
        }
        // Load User
        Task {
            try await self.loadUser()
        }
    }
    
}

// MARK: - App+ViewModel+reset

extension App.ViewModel {
    
    /// Reset ViewModel
    func reset() {
        // Disconnect all bikes
        try? self.user?
            .get()
            .bikes
            .forEach { bike in
                Task {
                    try await bike.disconnect()
                }
            }
        // Clear user
        self.user = nil
        // Clear selected bike id
        self.selectedBikeId = nil
    }
    
}

// MARK: - App+ViewModel+loadUser

extension App.ViewModel {
    
    /// Load User
    @discardableResult
    func loadUser() async throws -> VanMoof.User {
        // Retrieve user as a result
        let user: Result<VanMoof.User, Error> = await {
            do {
                return .success(
                    try await self.vanMoof.user()
                )
            } catch {
                return .failure(error)
            }
        }()
        // Run on MainActor
        await MainActor.run {
            // Set user
            self.user = user
            // Check if user is available
            if case .success(let user) = user {
                // Check if selected bike identifier has not been set
                if self.selectedBikeId == nil {
                    // Preselect first bike
                    self.selectedBikeId = user.bikes.first?.id
                }
                // Update AppShortcut Parameters
                App.updateAppShortcutParameters()
            }
        }
        // Return user or throw an error
        return try user.get()
    }
    
}
