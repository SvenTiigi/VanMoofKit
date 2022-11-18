import Foundation

// MARK: - VanMoof+Bike+Details+Key

public extension VanMoof.Bike.Details {
    
    /// The VanMoof Bike Key
    struct Key: Codable, Hashable {
        
        // MARK: Properties
        
        /// The encryption key.
        public let encryptionKey: String
        
        /// The passcode.
        public let passcode: String
        
        /// The user key identifier.
        public let userKeyId: Int
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.Details.Key`
        /// - Parameters:
        ///   - encryptionKey: The encryption key.
        ///   - passcode: The passcode.
        ///   - userKeyId: The user key identifier.
        public init(
            encryptionKey: String,
            passcode: String,
            userKeyId: Int
        ) {
            self.encryptionKey = encryptionKey
            self.passcode = passcode
            self.userKeyId = userKeyId
        }
        
    }
    
}
