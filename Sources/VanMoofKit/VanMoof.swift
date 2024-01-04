import Combine
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
    
    /// The VanMoofTokenStore will change cancellable.
    private var vanMoofTokenStoreWillChangeCancellable: AnyCancellable?
    
    // MARK: Initializer
    
    /// Creates a new instance of `VanMoof`
    /// - Parameters:
    ///   - apiURL: The VanMoof API URL. Default value `"https://my.vanmoof.com/api/v8"`
    ///   - apiKey: The VanMoof API Key. Default value `fcb38d47-f14b-30cf-843b-26283f6a5819`
    ///   - tokenStore: The VanMoofTokenStore. Default value `.userDefaults()`
    ///   - urlSession: The URLSession. Default value `.shared`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    public init(
        apiURL: URL = .init(string: "https://my.vanmoof.com/api/v8")!,
        apiKey: String = "fcb38d47-f14b-30cf-843b-26283f6a5819",
        tokenStore: VanMoofTokenStore = .userDefaults(),
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        let tokenStore = ObservableObjectVanMoofTokenMediator(tokenStore)
        self.apiURL = apiURL
        self.apiKey = apiKey
        self.tokenStore = tokenStore
        self.urlSession = urlSession
        self.decoder = decoder
        // Subscribe to object will change on VanMoofTokenStore
        self.vanMoofTokenStoreWillChangeCancellable = tokenStore
            .objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // Redirect changes
                self?.objectWillChange.send()
            }
    }
    
}

// MARK: - AuthenticationState

public extension VanMoof {
    
    /// The authentication state.
    var authenticationState: AuthenticationState {
        get async {
            .init(token: try? await self.tokenStore.token())
        }
    }
    
    /// A publisher that emits the current state of authentication.
    var authenticationStatePublisher: some Publisher<AuthenticationState, Never> {
        Just(())
            .merge(with: self.objectWillChange)
            .flatMap {
                Future { promise in
                    Task { [weak self] in
                        guard let self = self else {
                            return promise(.success(nil))
                        }
                        promise(.success(await self.authenticationState))
                    }
                }
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
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
        try await self.tokenStore.save(token: token)
        // Return token
        return token
    }
    
}

// MARK: - Logout

public extension VanMoof {
    
    /// Logout the user
    func logout() async throws {
        // Remove token
        try await self.tokenStore.removeToken()
    }
    
}

// MARK: - User

public extension VanMoof {
    
    /// Retrieve the currently authenticated VanMoof User.
    /// - Returns: The User
    func user() async throws -> User {
        /// The ResponseBody
        struct ResponseBody: Codable {
            /// The User
            let data: User
        }
        // Try to decode user data as ResponseBody to access the user
        return try self.decoder
            .decode(
                ResponseBody.self,
                from: await self.userData()
            )
            .data
    }
    
    /// Retrieve the VanMoof User Data of the currently authenticated user.
    func userData() async throws -> Data {
        /// Retrieve the VanMoof User Data
        /// - Parameter refreshedToken: The optional refreshed Token. Default value `nil`
        func userData(
            refreshedToken: Token? = nil
        ) async throws -> Data {
            // Verify token is available
            guard let token = try await self.tokenStore.token() else {
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
                return try await userData(
                    refreshedToken: self.refresh(
                        token: token
                    )
                )
            }
            // Return user data
            return data
        }
        // Return user data
        return try await userData()
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
        try await self.tokenStore.save(token: token)
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
        case customerData = "getCustomerData"
        case token
        
        /// The query items, if any.
        var queryItems: [URLQueryItem]? {
            switch self {
            case .authenticate:
                return nil
            case .customerData:
                return [
                    .init(
                        name: "includeBikeDetails",
                        value: nil
                    )
                ]
            case .token:
                return nil
            }
        }
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
    ) throws {
        guard let url: URL = {
            var urlComponents = URLComponents(
                url: url.appendingPathComponent(path.rawValue),
                resolvingAgainstBaseURL: true
            )
            if let queryItems = path.queryItems {
                urlComponents?.queryItems = queryItems
            }
            return urlComponents?.url
        }() else {
            throw URLError(.badURL)
        }
        self.init(
            url: url
        )
        self.httpMethod = method.rawValue
        self.setValue(
            apiKey,
            forHTTPHeaderField: "Api-Key"
        )
        self.setValue(
            {
                switch authorization {
                case .basic(let credentials):
                    return [
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
                    .joined(separator: " ")
                case .bearerToken(let token):
                    return [
                        "Bearer",
                        token
                    ]
                    .joined(separator: " ")
                }
            }(),
            forHTTPHeaderField: "Authorization"
        )
    }
    
}
