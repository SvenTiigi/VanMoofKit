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
    }
    
}

// MARK: - Is Authenticated

public extension VanMoof {
    
    /// Bool value if user is authenticated / logged in
    var isAuthenticated: Bool {
        self.tokenStore.token != nil
    }
    
}

// MARK: - Login

public extension VanMoof {
    
    /// Login with username and password
    /// - Parameters:
    ///   - username: The username.
    ///   - password: The password.
    /// - Returns: The VanMoof Token
    @discardableResult
    func login(
        username: String,
        password: String
    ) async throws -> Token {
        try await self.login(
            using: .init(
                username: username,
                password: password
            )
        )
    }
    
    /// Login using Credentials.
    /// - Parameter credentials: The VanMoof Credentials.
    /// - Returns: The VanMoof Token
    @discardableResult
    func login(
        using credentials: Credentials
    ) async throws -> Token {
        // Perform data task
        let (data, _) = try await self.urlSession.data(
            for: .init(
                url: self.url,
                path: "authenticate",
                method: "POST",
                apiKey: self.apiKey,
                credentials: credentials
            )
        )
        // Try to decode token
        let token = try self.decoder.decode(Token.self, from: data)
        // Set Token
        try self.tokenStore.set(token: token)
        // Run on MainActor
        await MainActor.run { [weak self] in
            // Send object will change
            self?.objectWillChange.send()
        }
        // Return token
        return token
    }
    
}

// MARK: - Logout

public extension VanMoof {
    
    /// Logout the user
    func logout() {
        // Remove Token
        self.tokenStore.remove()
        // Send object will change
        self.objectWillChange.send()
    }
    
}

// MARK: - User

public extension VanMoof {
    
    /// Retrieve the VanMoof User which is currently authenticated
    /// - Returns: The User
    func user() async throws -> User {
        /// Retrieve the VanMoof User
        /// - Parameter refreshedToken: The optional refreshed Token. Default value `nil`
        func user(
            refreshedToken: Token? = nil
        ) async throws -> User {
            // Verify token is available
            guard let token = self.tokenStore.token else {
                // Otherwise throw error
                throw Token.MissingError()
            }
            // Perform data task
            let (data, response) = try await self.urlSession.data(
                for: .init(
                    url: self.url,
                    path: "getCustomerData?includeBikeDetails",
                    method: "GET",
                    apiKey: self.apiKey,
                    token: token.accessToken
                )
            )
            // Check if should refresh the token if needed and status code is `401`
            if refreshedToken == nil, (response as? HTTPURLResponse)?.statusCode == 401 {
                // Return user without refreshing token again
                return try await user(
                    refreshedToken: self.refresh(
                        token: token
                    )
                )
            }
            /// The ResponseBody
            struct ResponseBody: Codable {
                /// The User
                let data: User
            }
            // Try to decode data as ResponseBody to access the user
            return try self.decoder.decode(ResponseBody.self, from: data).data
        }
        // Return user
        return try await user()
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

// MARK: - Refresh Token

public extension VanMoof {
    
    /// Refresh Token
    /// - Parameter token: The VanMoof Token which should be refreshed
    /// - Returns: The refreshed VanMoof Token
    @discardableResult
    func refresh(
        token: Token
    ) async throws -> Token {
        // Perform data task
        let (data, _) = try await self.urlSession.data(
            for: .init(
                url: self.url,
                path: "token",
                method: "POST",
                apiKey: self.apiKey,
                token: token.refreshToken
            )
        )
        // Try to decode token
        let newToken = try self.decoder.decode(Token.self, from: data)
        // Try to set token
        try self.tokenStore.set(token: token)
        // Return token
        return newToken
    }
    
}

// MARK: - URLRequest+init

private extension URLRequest {
    
    /// Creates a new instance of `URLRequest`
    /// - Parameters:
    ///   - url: The URL.
    ///   - path: The path.
    ///   - method: The http method.
    ///   - apiKey: The API Key.
    ///   - credentials: The optional VanMoof Credentials. Default value `nil`
    ///   - token: The optional VanMoof Token value. Default value `nil`
    init(
        url: URL,
        path: String,
        method: String,
        apiKey: String,
        credentials: VanMoof.Credentials? = nil,
        token: String? = nil
    ) {
        self.init(
            url: url.appendingPathComponent(path)
        )
        self.httpMethod = method
        self.setValue(
            apiKey,
            forHTTPHeaderField: "Api-Key"
        )
        if let credentials = credentials {
            self.setValue(
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
        } else if let token = token {
            self.setValue(
                [
                    "Bearer",
                    token
                ]
                .joined(separator: " "),
                forHTTPHeaderField: "Authorization"
            )
        }
    }
    
}
