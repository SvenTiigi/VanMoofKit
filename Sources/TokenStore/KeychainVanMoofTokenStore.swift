import Foundation
import Security

// MARK: - KeychainVanMoofTokenStore

/// A Keychain based VanMoofTokenStore
public struct KeychainVanMoofTokenStore {
    
    // MARK: Properties
    
    /// The name of the key.
    public let keyName: String
    
    /// The service.
    public let service: String
    
    /// The optional access group.
    public let acccessGroup: String?
    
    /// Bool value if token should be synchronized with iCloud.
    public let isSynchronizable: Bool
    
    // MARK: Initializer
    
    /// Creates a new instance of `KeychainVanMoofTokenStore`
    /// - Parameters:
    ///   - keyName: The name of the key. Default value `VanMoof.Token`
    ///   - service: The service. Default value `Bundle.main.bundleIdentifier`
    ///   - acccessGroup: The optional access group. Default value `nil`
    ///   - isSynchronizable: Bool value if token should be synchronized with iCloud. Default value `false`
    public init(
        keyName: String = "VanMoof.Token",
        service: String = Bundle.main.bundleIdentifier ?? "VanMoofKit",
        acccessGroup: String? = nil,
        isSynchronizable: Bool = false
    ) {
        self.keyName = keyName
        self.service = service
        self.acccessGroup = acccessGroup
        self.isSynchronizable = isSynchronizable
    }
    
}

// MARK: - Error

public extension KeychainVanMoofTokenStore {
    
    /// A KeychainVanMoofTokenStore Error
    struct Error: Codable, Hashable, Swift.Error {
        
        // MARK: Properties
        
        /// The OSStatus of the Error.
        public let status: OSStatus
        
        // MARK: Initializer
        
        /// Creates a new instance of `KeychainVanMoofTokenStore.Error`
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
    
    /// The VanMoof Token, if available
    public var token: VanMoof.Token? {
        var result: AnyObject?
        _ = withUnsafeMutablePointer(to: &result) { result in
            SecItemCopyMatching(
                self.query(
                    parameters: [
                        kSecMatchLimit: kSecMatchLimitOne,
                        kSecReturnData: kCFBooleanTrue
                    ]
                ),
                .init(result)
            )
        }
        guard let data = result as? Data else {
            return nil
        }
        return try? JSONDecoder()
            .decode(
                VanMoof.Token.self,
                from: data
            )
    }
    
    /// Set VanMoof Token
    /// - Parameter token: The VanMoof Token that should be set
    public func set(token: VanMoof.Token) throws {
        let encodedToken = try JSONEncoder().encode(token)
        var parameters = [CFString: Any?]()
        parameters[kSecValueData] = encodedToken
        parameters[kSecAttrSynchronizable] = self.isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
        let status: OSStatus = try {
            let existsStatus = SecItemCopyMatching(
                self.query(
                    parameters: [
                        kSecMatchLimit: kSecMatchLimitOne,
                        kSecReturnData: kCFBooleanFalse
                    ]
                ),
                nil
            )
            switch existsStatus {
            case errSecItemNotFound:
                return SecItemAdd(
                    self.query(
                        parameters: parameters
                    ),
                    nil
                )
            case errSecSuccess:
                return SecItemUpdate(
                    self.query(),
                    parameters.convert()
                )
            default:
                throw Error(status: existsStatus)
            }
        }()
        if status != errSecSuccess {
            throw Error(status: status)
        }
    }
    
    /// Remove VanMoof Token
    public func remove() {
        SecItemDelete(self.query())
    }
    
}

// MARK: - Query

private extension KeychainVanMoofTokenStore {
    
    /// Make Keychain query with parameters
    /// - Parameter parameters: The parameters. Default value `.init()`
    func query(
        parameters: [CFString: Any?] = .init()
    ) -> CFDictionary {
        var parameters = parameters
        parameters[kSecClass] = kSecClassGenericPassword
        parameters[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        parameters[kSecAttrService] = self.service
        if let acccessGroup = self.acccessGroup {
            parameters[kSecAttrAccessGroup] = acccessGroup
        }
        parameters[kSecAttrAccount] = self.keyName
        return parameters.convert()
    }
    
}

// MARK: - Dictionary<CFString, Any?>+convert()

private extension Dictionary where Key == CFString, Value == Any? {
    
    /// Convert Dictionary to CFDictionary
    func convert() -> CFDictionary {
        var dictionary: [String: Any] = .init()
        for element in self {
            guard let value = element.value else {
                continue
            }
            dictionary[element.key as String] = value
        }
        return dictionary as CFDictionary
    }
    
}
