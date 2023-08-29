import Foundation

// MARK: - VanMoof+AuthenticationState

public extension VanMoof {
    
    /// A VanMoof authentication state.
    enum AuthenticationState: Codable, Hashable, Sendable {
        /// Authenticated.
        case authenticated(Token)
        /// Unauthenticated.
        case unauthenticated
    }
    
}

// MARK: - AuthenticationState+init(token:)

public extension VanMoof.AuthenticationState {
    
    /// Creates a new instance of `VanMoof.AuthenticationState`.
    /// When a VanMoof Token is present the enum will be initialized with the case `authenticated`
    /// otherwise it will be initialized with the case `.unauthenticated`
    /// - Parameter token: The VanMoof token, if available.
    init(
        token: VanMoof.Token?
    ) {
        self = token.flatMap(Self.authenticated) ?? .unauthenticated
    }
    
}

// MARK: - AuthenticationState+Identifiable

extension VanMoof.AuthenticationState: Identifiable {
    
    /// The stable identity of the entity associated with this instance.
    public var id: String {
        switch self {
        case .authenticated:
            return "authenticated"
        case .unauthenticated:
            return "unauthenticated"
        }
    }
    
}

// MARK: - AuthenticationState+isAuthenticated

public extension VanMoof.AuthenticationState {
    
    /// Bool value if is authenticated.
    var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - AuthenticationState+isUnauthenticated

public extension VanMoof.AuthenticationState {
    
    /// Bool value if is unauthenticated.
    var isUnauthenticated: Bool {
        if case .unauthenticated = self {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - AuthenticationState+token

public extension VanMoof.AuthenticationState {
    
    /// The VanMoof token, if available.
    var token: VanMoof.Token? {
        if case .authenticated(let token) = self {
            return token
        } else {
            return nil
        }
    }
    
}
