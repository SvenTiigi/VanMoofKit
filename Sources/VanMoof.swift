import Foundation

// MARK: - VanMoof

/// A VanMoof object
public final class VanMoof: ObservableObject {
    
    // MARK: Properties
    
    /// The VanMoof API URL.
    private let url: URL
    
    /// The VanMoof API Key.
    private let apiKey: String
    
    /// The VanMoofTokenStore.
    private let tokenStore: VanMoofTokenStore
    
    /// The URLSession.
    private let urlSession: URLSession

    /// The JSONDecoder.
    private let decoder: JSONDecoder
    
    /// The Token
    @Published
    private var token: Token? {
        didSet {
            // Check if Token is available
            if let token = self.token {
                // Set Token
                self.tokenStore.set(token: token)
            } else {
                // Remove Token
                self.tokenStore.remove()
            }
        }
    }
    
    // MARK: Initializer
    
    /// Creates a new instance of `VanMoof`
    /// - Parameters:
    ///   - url: The VanMoof API URL. Default value `"https://my.vanmoof.com/api/v8"`
    ///   - apiKey: The VanMoof API Key. Default value `fcb38d47-f14b-30cf-843b-26283f6a5819`
    ///   - tokenStore: The VanMoofTokenStore. Default value `UserDefaultsVanMoofTokenStore()`
    ///   - urlSession: The URLSession. Default value `.shared`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    public init(
        url: URL = .init(string: "https://my.vanmoof.com/api/v8")!,
        apiKey: String = "fcb38d47-f14b-30cf-843b-26283f6a5819",
        tokenStore: VanMoofTokenStore = UserDefaultsVanMoofTokenStore(),
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.url = url
        self.apiKey = apiKey
        self.tokenStore = tokenStore
        self.urlSession = urlSession
        self.decoder = decoder
        self.token = self.tokenStore.token
    }
    
}

// MARK: - Is Authentication

public extension VanMoof {
    
    /// Bool value if user is authenticated
    var isAuthenticated: Bool {
        self.token != nil
    }
    
}

// MARK: - Authenticate

public extension VanMoof {
    
    /// Authenticate using username and password
    /// - Parameter credentials: The VanMoof Credentials
    /// - Returns: The VanMoof Token
    @discardableResult
    func authenticate(
        using credentials: Credentials
    ) async throws -> Token {
        // Initialize mutable URLRequest
        var urlRequest = URLRequest(
            url: self.url.appendingPathComponent("authenticate")
        )
        // Set http method
        urlRequest.httpMethod = "POST"
        // Set api key
        urlRequest.setValue(
            self.apiKey,
            forHTTPHeaderField: "Api-Key"
        )
        // Set authorization header
        urlRequest.setValue(
            [
                "Basic",
                Data(
                    [
                        credentials.username,
                        credentials.password
                    ]
                    .joined(separator: ":")
                    .utf8
                )
                .base64EncodedString()
            ]
            .joined(separator: " "),
            forHTTPHeaderField: "Authorization"
        )
        // Perform data task
        let (data, _) = try await self.urlSession.data(for: urlRequest)
        // Try to decode token
        let token = try self.decoder.decode(Token.self, from: data)
        // Run on MainActor
        await MainActor.run {
            // Set token
            self.token = token
        }
        // Return token
        return token
    }
    
}

// MARK: - Refresh Authentication

public extension VanMoof {
    
    /// Refresh Authentication
    /// - Returns: The VanMoof Token
    @discardableResult
    func refreshAuthentication() async throws -> Token {
        // Verify token is available
        guard let token = self.token else {
            // Otherwise throw error
            throw Token.MissingError()
        }
        // Initialize mutable URLRequest
        var urlRequest = URLRequest(
            url: self.url.appendingPathComponent("token")
        )
        // Set http method
        urlRequest.httpMethod = "POST"
        // Set authorization header
        urlRequest.setValue(
            self.apiKey,
            forHTTPHeaderField: "Api-Key"
        )
        urlRequest.setValue(
            [
                "Bearer",
                token.refreshToken
            ]
            .joined(separator: " "),
            forHTTPHeaderField: "Authorization"
        )
        // Perform data task
        let (data, _) = try await self.urlSession.data(for: urlRequest)
        // Try to decode token
        let newToken = try self.decoder.decode(Token.self, from: data)
        // Run on MainActor
        await MainActor.run {
            // Set token
            self.token = newToken
        }
        // Return token
        return newToken
    }
    
}

// MARK: - Logout

public extension VanMoof {
    
    /// Logout the user
    func logout() {
        // Clear token
        self.token = nil
    }
    
}

// MARK: - User

public extension VanMoof {
    
    /// Retrieve the VanMoof User which is currently authenticated
    /// - Returns: The User
    func user() async throws -> User {
        /// Retrieve the VanMoof User
        /// - Parameter refreshTokenIfNeeded: Bool value if token should be refreshed on a `401` status code
        func user(
            refreshTokenIfNeeded: Bool
        ) async throws -> User {
            // Verify token is available
            guard let token = self.token else {
                // Otherwise throw error
                throw Token.MissingError()
            }
            // Initialize mutable URLRequest
            var urlRequest = URLRequest(
                url: self.url.appendingPathComponent("getCustomerData?includeBikeDetails")
            )
            // Set http method
            urlRequest.httpMethod = "GET"
            // Set api key
            urlRequest.setValue(
                self.apiKey,
                forHTTPHeaderField: "Api-Key"
            )
            // Set authorization header
            urlRequest.setValue(
                [
                    "Bearer",
                    token.accessToken
                ]
                .joined(separator: " "),
                forHTTPHeaderField: "Authorization"
            )
            // Perform data task
            let (data, response) = try await self.urlSession.data(for: urlRequest)
            // Check if shoudl refresh token if needed and status code is `401`
            if refreshTokenIfNeeded, (response as? HTTPURLResponse)?.statusCode == 401 {
                // Refresh authentication
                try await self.refreshAuthentication()
                // Return user without refreshing token again, if needed
                return try await user(refreshTokenIfNeeded: false)
            }
            /// The ResponseBody
            struct ResponseBody: Codable {
                /// The User
                let data: User
            }
            // Try to decode data as ResponseBody to access the user
            return try self.decoder.decode(ResponseBody.self, from: data).data
        }
        // Return user (refresh token if needed)
        return try await user(refreshTokenIfNeeded: true)
    }
    
}

// MARK: - Bikes

public extension VanMoof {
    
    /// Retrieve the VanMoof Bikes of the currently authenticated user
    /// - Returns: The Bikes
    func bikes() async throws -> [Bike] {
        try await self.user().bikes
    }
    
}
