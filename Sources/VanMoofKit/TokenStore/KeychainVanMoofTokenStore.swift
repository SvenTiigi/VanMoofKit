import Foundation
import Security

// MARK: - KeychainVanMoofTokenStore

/// A Keychain based VanMoofTokenStore.
public final class KeychainVanMoofTokenStore: ObservableObject {
    
    // MARK: Properties
    
    /// The key.
    public var key: String
    
    /// The service.
    public var service: String?
    
    /// The access group.
    public var accessGroup: String?
    
    /// Bool value if keychain item should be synchronized with the iCloud.
    public var isSynchronizable: Bool
    
    /// The JSONDecoder.
    public var decoder: JSONDecoder
    
    /// The JSONEncoder.
    public var encoder: JSONEncoder
    
    // MARK: Initializer
    
    /// Creates a new instance of `KeychainVanMoofTokenStore`
    /// - Parameters:
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - service: The service. Default value `Bundle.main.bundleIdentifier`
    ///   - accessGroup: The access group. Default value `nil`
    ///   - isSynchronizable: Bool value if keychain item should be synchronized with the iCloud. Default value `true`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    public init(
        key: String = VanMoof.Token.key,
        service: String? = Bundle.main.bundleIdentifier,
        accessGroup: String? = nil,
        isSynchronizable: Bool = true,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.key = key
        self.service = service
        self.accessGroup = accessGroup
        self.isSynchronizable = isSynchronizable
        self.decoder = decoder
        self.encoder = encoder
    }
    
}

// MARK: - Error

public extension KeychainVanMoofTokenStore {
    
    /// A KeychainAuthSessionIDStore Error
    struct Error: Codable, Hashable, Sendable, Swift.Error {
        
        // MARK: Properties
        
        /// The OSStatus of the Error.
        public let status: OSStatus
        
        // MARK: Initializer
        
        /// Creates a new instance of `KeychainAuthSessionIDStore.Error`
        /// - Parameter status: The OSStatus of the Error.
        public init(
            status: OSStatus
        ) {
            self.status = status
        }
        
    }
    
}

// MARK: - VanMoofTokenStore

extension KeychainVanMoofTokenStore: VanMoofTokenStore {
    
    /// Retrieves the VanMoof token, if available
    public func token() async throws -> VanMoof.Token? {
        // Declare result
        var result: AnyObject?
        // Retrieve keychain item
        let status = try withUnsafeMutablePointer(
            to: &result
        ) { result in
            SecItemCopyMatching(
                try self.keychainQuery(
                    for: .secItemCopyMatching,
                    additionalKeys: [
                        kSecMatchLimit: kSecMatchLimitOne,
                        kSecReturnData: kCFBooleanTrue
                    ]
                ),
                result
            )
        }
        // Check if keychain item was not found
        if status == errSecItemNotFound {
            // Return nil
            return nil
        }
        // Verify statis is success and data is available from result
        guard status == errSecSuccess,
              let data = result as? Data else {
            // Otherwise throw an error
            throw Error(status: status)
        }
        // Try to decode token from data
        return try self.decoder
            .decode(
                VanMoof.Token.self,
                from: data
            )
    }
    
    /// Save VanMoof token.
    /// - Parameter token: The VanMoof token that should be saved.
    public func save(token: VanMoof.Token) async throws {
        // Initialize status
        let status: OSStatus = try {
            // Try to find keychain item
            let existsStatus = SecItemCopyMatching(
                try self.keychainQuery(
                    for: .secItemCopyMatching,
                    additionalKeys: [
                        kSecMatchLimit: kSecMatchLimitOne,
                        kSecReturnData: kCFBooleanFalse
                    ]
                ),
                nil
            )
            // Verify keychain item exists or has not been found
            guard existsStatus == errSecSuccess || existsStatus == errSecItemNotFound else {
                // Otherwise throw an error
                throw Error(status: existsStatus)
            }
            // Encode token
            let encodedToken = try self.encoder.encode(token)
            // Check if keychain item exists
            if existsStatus == errSecSuccess {
                // Update keychain item
                return try SecItemUpdate(
                    self.keychainQuery(
                        for: .secItemCopyMatching
                    ),
                    self.keychainQuery(
                        for: .secItemUpdate,
                        additionalKeys: [
                            kSecValueData: encodedToken
                        ]
                    )
                )
            } else {
                // Otherwise add keychain item
                return SecItemAdd(
                    try self.keychainQuery(
                        for: .secItemAdd,
                        additionalKeys: [
                            kSecValueData: encodedToken
                        ]
                    ),
                    nil
                )
            }
        }()
        // Verify status is a success
        guard status == errSecSuccess else {
            // Otherwise throw an error
            throw Error(status: status)
        }
        // Run on main actor
        await MainActor.run {
            // Send object will change
            self.objectWillChange.send()
        }
    }
    
    /// Remove VanMoof token.
    public func removeToken() async throws {
        // Delete keychain item
        let status = SecItemDelete(
            try self.keychainQuery(
                for: .secItemDelete
            )
        )
        // Verify status is either success or not found
        guard status == errSecSuccess || status == errSecItemNotFound else {
            // Otherwise throw an error
            throw Error(status: status)
        }
        // Run on main actor
        await MainActor.run {
            // Send object will change
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - KeychainQuery

private extension KeychainVanMoofTokenStore {
    
    /// A Keychain operation.
    enum KeychainOperation: String, Codable, Hashable, Sendable, CaseIterable {
        case secItemCopyMatching
        case secItemUpdate
        case secItemAdd
        case secItemDelete
    }
    
    /// Retrieves a keychain query dictionary based on the provided parameters.
    /// - Parameters:
    ///   - additionalKeys: Additional key-value pairs to include in the query. Default is an empty dictionary.
    /// - Returns: A Core Foundation dictionary representing the keychain query.
    func keychainQuery(
        for operation: KeychainOperation,
        additionalKeys: [CFString: Any?] = .init()
    ) throws -> CFDictionary {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: self.key
        ]
        if let service {
            query[kSecAttrService as String] = service
        }
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        query[kSecAttrSynchronizable as String] = {
            switch operation {
            case .secItemAdd, .secItemUpdate:
                return self.isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
            default:
                return kSecAttrSynchronizableAny
            }
        }()
        for (key, value) in additionalKeys {
            guard let value = value else {
                continue
            }
            query[key as String] = value
        }
        return query as CFDictionary
    }
    
}

// MARK: - VanMoofTokenStore+keychain()

public extension VanMoofTokenStore where Self == KeychainVanMoofTokenStore {
    
    /// Creates a keychain based VanMoofTokenStore.
    /// - Parameters:
    ///   - key: The key. Default value `VanMoof.Token.key`
    ///   - service: The service. Default value `Bundle.main.bundleIdentifier`
    ///   - accessGroup: The access group. Default value `nil`
    ///   - isSynchronizable: Bool value if keychain item should be synchronized with the iCloud. Default value `true`
    ///   - decoder: The JSONDecoder. Default value `.init()`
    ///   - encoder: The JSONEncoder. Default value `.init()`
    static func keychain(
        key: String = VanMoof.Token.key,
        service: String? = Bundle.main.bundleIdentifier,
        accessGroup: String? = nil,
        isSynchronizable: Bool = true,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) -> Self {
        .init(
            key: key,
            service: service,
            accessGroup: accessGroup,
            isSynchronizable: isSynchronizable,
            decoder: decoder,
            encoder: encoder
        )
    }
    
}
