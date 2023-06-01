import CommonCrypto
import Foundation

// MARK: - VanMoof+Bike+BluetoothCrypto

extension VanMoof.Bike {
    
    /// The VanMoof Bike Bluetooth Crypto.
    struct BluetoothCrypto: Codable, Hashable, Sendable {
        
        // MARK: Properties
        
        /// The key of the bike.
        let key: Details.Key
        
        /// The key bytes.
        private let keyBytes: [UInt8]
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.BluetoothCrypto`
        /// - Parameter key: The key of the bike.
        init(
            key: Details.Key
        ) {
            self.key = key
            self.keyBytes = .init(
                hex: key.encryptionKey
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
        try self(.encrypt, bytes: bytes)
    }
    
    /// Encrypt data.
    /// - Parameter data: The data to encrypt.
    /// - Returns: The encrypted data.
    func encrypt(
        data: Data
    ) throws -> Data {
        try .init(self.encrypt(bytes: .init(data)))
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
        try self(.decrypt, bytes: bytes)
    }
    
    /// Decrypt data.
    /// - Parameter data: The data to decrypt.
    /// - Returns: The decrypted data.
    func decrypt(
        data: Data
    ) throws -> Data {
        try .init(self.decrypt(bytes: .init(data)))
    }
    
}

// MARK: - BluetoothCrypto+callAsFunction

private extension VanMoof.Bike.BluetoothCrypto {
    
    /// A crypto operation
    enum Operation: String {
        /// Encrypt
        case encrypt
        /// Decrypt
        case decrypt
    }
    
    /// Call BluetoothCrypto as function to either encrypt or decrypt
    /// the given bytes using AES with ECB block mode.
    /// - Parameters:
    ///   - operation: The operation.
    ///   - bytes: The bytes.
    func callAsFunction(
        _ operation: Operation,
        bytes: [UInt8]
    ) throws -> [UInt8] {
        // Initialize the count of bytes
        let bytesCount = bytes.count
        // Initialize the length of bytes to either encrypt or decrypt
        let cryptLength = bytesCount + CommonCrypto.kCCBlockSizeAES128
        // Initialize the output bytes
        var outputBytes = [UInt8](repeating: 0, count: cryptLength)
        // Initialize the count of bytes which have been outputted
        var outputCount = 0
        // Perform encrypt or decrypt operation using AES with ECB block mode
        let cryptStatus = CommonCrypto.CCCrypt(
            .init({
                switch operation {
                case .encrypt:
                    return CommonCrypto.kCCEncrypt
                case .decrypt:
                    return CommonCrypto.kCCDecrypt
                }
            }()),
            .init(CommonCrypto.kCCAlgorithmAES128),
            .init(CommonCrypto.kCCOptionECBMode),
            self.keyBytes,
            CommonCrypto.kCCKeySizeAES128,
            nil,
            bytes,
            bytesCount,
            &outputBytes,
            cryptLength,
            &outputCount
        )
        // Verify operation was successfull
        guard cryptStatus == CommonCrypto.kCCSuccess else {
            // Otherwise throw an error
            throw VanMoof.Bike.Error(
                errorDescription: [
                    "\(operation.rawValue.capitalized)ion error",
                    {
                        if cryptStatus == CommonCrypto.kCCBufferTooSmall {
                            return "Supplied insufficent space for output bytes (kCCBufferTooSmall)"
                        } else if cryptStatus == CommonCrypto.kCCAlignmentError {
                            return "Bytes not properly aligned (kCCAlignmentError)"
                        } else if cryptStatus == CommonCrypto.kCCDecodeError {
                            return "Invalid key (kCCDecodeError)"
                        } else {
                            return "CCCryptorStatus: \(cryptStatus)"
                        }
                    }()
                ]
                .joined(separator: ". ")
            )
        }
        // Only keep the actual bytes which have ben outputted
        outputBytes.removeSubrange(outputCount..<outputBytes.count)
        // Return encrypted/decrypted bytes
        return outputBytes
    }
    
}

// MARK: - [UInt8]+init(hex:)

private extension Array where Element == UInt8 {
    
    /// Creates a new instance from an hex string.
    /// - Parameter hex: The hex string.
    init(
        hex: String
    ) {
        self = .init()
        self.reserveCapacity(hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        hex.dropFirst(hex.hasPrefix("0x") ? 2 : 0).forEach { char in
            guard let value = UInt8(String(char), radix: 16) else {
                self.removeAll()
                return
            }
            if let currentBuffer = buffer {
                self.append(currentBuffer << 4 | value)
                buffer = nil
            } else {
                buffer = value
            }
        }
        if let buffer = buffer {
            self.append(buffer)
        }
    }
    
}
