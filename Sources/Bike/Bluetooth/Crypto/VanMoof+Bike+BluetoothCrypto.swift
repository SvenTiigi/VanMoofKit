import CryptoSwift
import Foundation

// MARK: - VanMoof+Bike+BluetoothCrypto

extension VanMoof.Bike {
    
    /// The VanMoof Bike Bluetooth Crypto.
    struct BluetoothCrypto: Codable, Hashable, Sendable {
        
        /// The Key.
        let key: Details.Key
        
    }
    
}

// MARK: - BluetoothCrypto+aesECB

private extension VanMoof.Bike.BluetoothCrypto {
    
    /// The Advanced Encryption Standard (`AES`) with Electronic Code Book (`ECB`) block mode.
    var aesECB: CryptoSwift.AES {
        get throws {
            try CryptoSwift.AES(
                key: .init(
                    hex: self.key.encryptionKey
                ),
                blockMode: CryptoSwift.ECB(),
                padding: .noPadding
            )
        }
    }
    
}

// MARK: - BluetoothCrypto+encrypt

extension VanMoof.Bike.BluetoothCrypto {
    
    /// Encrypt bytes.
    /// - Parameter bytes: The bytes to encrypt.
    /// - Returns: The encrypted bytes.
    func encrypt(
        bytes: [UInt8]
    ) throws -> [UInt8] {
        do {
            return try self.aesECB.encrypt(bytes)
        } catch {
            throw VanMoof.Bike.Error(
                errorDescription: "Encryption Error",
                underlyingError: error
            )
        }
    }
    
    /// Encrypt data.
    /// - Parameter data: The data to encrypt.
    /// - Returns: The encrypted data.
    func encrypt(
        data: Data
    ) throws -> Data {
        try .init(
            self.encrypt(
                bytes: .init(data)
            )
        )
    }
    
}

// MARK: - BluetoothCrypto+decrypt

extension VanMoof.Bike.BluetoothCrypto {
    
    /// Decrypt bytes.
    /// - Parameter bytes: The bytes to decrypt.
    /// - Returns: The decrypted bytes.
    func decrypt(
        bytes: [UInt8]
    ) throws -> [UInt8] {
        do {
            return try self.aesECB.decrypt(bytes)
        } catch {
            throw VanMoof.Bike.Error(
                errorDescription: "Decryption Error",
                underlyingError: error
            )
        }
    }
    
    /// Decrypt data.
    /// - Parameter data: The data to decrypt.
    /// - Returns: The decrypted data.
    func decrypt(
        data: Data
    ) throws -> Data {
        try .init(
            self.decrypt(
                bytes: .init(data)
            )
        )
    }
    
}
