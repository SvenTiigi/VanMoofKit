import Foundation

// MARK: - VanMoofTokenStore

/// A VanMoof Token Store type
public protocol VanMoofTokenStore {
    
    /// The VanMoof Token, if available
    var token: VanMoof.Token? { get }
    
    /// Set VanMoof Token
    /// - Parameter token: The VanMoof Token that should be set
    func set(token: VanMoof.Token)
    
    /// Remove VanMoof Token
    func remove()
    
}
