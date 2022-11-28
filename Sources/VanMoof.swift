import Foundation

// MARK: - VanMoof

/// A VanMoof object
public final class VanMoof: ObservableObject {
    
    // MARK: Static-Properties
    
    /// The default `VanMoof` instance
    public static var `default` = VanMoof()
    
    // MARK: Properties
    
    /// The VanMoof API URL.
    public var apiURL: URL
    
    /// The VanMoof API Key.
    public var apiKey: String
    
    /// The VanMoofTokenStore.
    public var tokenStore: VanMoofTokenStore
    
    /// The URLSession.
    public var urlSession: URLSession

    /// The JSONDecoder.
    public var decoder: JSONDecoder
    
    // MARK: Initializer
    
    /// Creates a new instance of `VanMoof`
    /// - Parameters:
    ///   - apiURL: The VanMoof API URL. Default value `"https://my.vanmoof.com/api/v8"`
    ///   - apiKey: The VanMoof API Key. Default value `fcb38d47-f14b-30cf-843b-26283f6a5819`
    ///   - tokenStore: The VanMoofTokenStore. Default value `UserDefaultsVanMoofTokenStore()`
    ///   - urlSession: The URLSession. Default value `.shared`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    public init(
        apiURL: URL = .init(string: "https://my.vanmoof.com/api/v8")!,
        apiKey: String = "fcb38d47-f14b-30cf-843b-26283f6a5819",
        tokenStore: VanMoofTokenStore = UserDefaultsVanMoofTokenStore(),
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.apiURL = apiURL
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
                url: self.apiURL,
                path: .authenticate,
                method: .post,
                apiKey: self.apiKey,
                authorization: .basic(credentials)
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
                    url: self.apiURL,
                    path: .customerData,
                    method: .get,
                    apiKey: self.apiKey,
                    authorization: .bearerToken(token.accessToken)
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
                url: self.apiURL,
                path: .token,
                method: .post,
                apiKey: self.apiKey,
                authorization: .bearerToken(token.refreshToken)
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
    
    /// A HTTP method
    enum HTTPMethod: String {
        /// GET
        case get = "GET"
        /// POST
        case post = "POST"
    }
    
    /// A Path
    enum Path: String {
        case authenticate
        case customerData = "getCustomerData?includeBikeDetails"
        case token
    }
    
    /// The Authorization
    enum Authorization {
        /// Basic Authorization using VanMoof Credentials
        case basic(VanMoof.Credentials)
        /// Bearer Token
        case bearerToken(String)
    }
    
    /// Creates a new instance of `URLRequest`
    /// - Parameters:
    ///   - url: The URL.
    ///   - path: The Path.
    ///   - method: The HTTPMethod.
    ///   - apiKey: The API Key.
    ///   - authorization: The Authorization.
    init(
        url: URL,
        path: Path,
        method: HTTPMethod,
        apiKey: String,
        authorization: Authorization
    ) {
        self.init(
            url: url.appendingPathComponent(path.rawValue)
        )
        self.httpMethod = method.rawValue
        self.setValue(
            apiKey,
            forHTTPHeaderField: "Api-Key"
        )
        switch authorization {
        case .basic(let credentials):
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
        case .bearerToken(let token):
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
