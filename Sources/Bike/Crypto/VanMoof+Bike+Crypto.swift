import CryptoSwift
import Foundation

// MARK: - VanMoof+Bike+Crypto

extension VanMoof.Bike {
    
    /// The VanMoof Bike Crypto
    struct Crypto {
        
        /// The Key
        let key: Details.Key
        
    }
    
}

// MARK: - Crypto+encrypt

extension VanMoof.Bike.Crypto {
    
    /// Encrypt bytes
    /// - Parameter bytes: The bytes to encrypt
    /// - Returns: The encrypted bytes
    func encrypt(
        bytes: ArraySlice<UInt8>
    ) throws -> Array<UInt8> {
        try CryptoSwift.AES(
            key: self.key.encryptionKey.bytes,
            blockMode: CryptoSwift.ECB()
        )
        .encrypt(bytes)
    }
    
    /// Encrypt data
    /// - Parameter data: The data to encrypt
    /// - Returns: The encrypted data
    func encrypt(
        data: Data
    ) throws -> Data {
        try .init(
            self.encrypt(
                bytes: .init(data.bytes)
            )
        )
    }
    
}

// MARK: - Crypto+decrypt

extension VanMoof.Bike.Crypto {
    
    /// Decrypt bytes
    /// - Parameter bytes: The bytes to decrypt
    /// - Returns: The decrypted bytes
    func decrypt(
        bytes: ArraySlice<UInt8>
    ) throws -> Array<UInt8> {
        try CryptoSwift.AES(
            key: self.key.encryptionKey.bytes,
            blockMode: CryptoSwift.ECB()
        )
        .decrypt(bytes)
    }
    
    /// Decrypt data
    /// - Parameter data: The data to decrypt
    /// - Returns: The decrypted data
    func decrypt(
        data: Data
    ) throws -> Data {
        try .init(
            self.decrypt(
                bytes: .init(data.bytes)
            )
        )
    }
    
}
