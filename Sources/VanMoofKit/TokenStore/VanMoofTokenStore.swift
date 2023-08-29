import Foundation

// MARK: - VanMoofTokenStore

/// A VanMoof Token store type which can read, save and remove a VanMoof token.
public protocol VanMoofTokenStore: ReadableVanMoofTokenStore, SaveableVanMoofTokenStore, RemovableVanMoofTokenStore {}

// MARK: - ReadableVanMoofTokenStore

/// A readable VanMoof token store type.
public protocol ReadableVanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    func token() async throws -> VanMoof.Token?
    
}

// MARK: - SaveableVanMoofTokenStore

/// A saveable VanMoof token store type.
public protocol SaveableVanMoofTokenStore {
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    func save(token: VanMoof.Token) async throws
    
}

// MARK: - RemovableVanMoofTokenStore

/// A removable VanMoof token store type.
public protocol RemovableVanMoofTokenStore {
    
    /// Remove VanMoof token.
    func removeToken() async throws
    
}

