import Foundation

// MARK: - VanMoof+Bike+BluetoothData

extension VanMoof.Bike {
    
    /// A VanMoof Bike Bluetooth byte buffer.
    struct BluetoothData: Codable, Hashable {
        
        // MARK: Properties
        
        /// The raw value represented as `Data`.
        let rawValue: Data
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.BluetoothData`
        /// - Parameter rawValue: The raw value.
        init(
            _ rawValue: Data
        ) {
            self.rawValue = rawValue
        }
        
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+init(bytes:)

extension VanMoof.Bike.BluetoothData {
    
    /// Creates a new instance of `VanMoof.Bike.BluetoothData`
    /// - Parameter bytes: A UInt8 byte array.
    init(
        _ bytes: [UInt8]
    ) {
        self.init(.init(bytes))
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+init(integerValue:)

extension VanMoof.Bike.BluetoothData {
    
    /// Creates a new instance of `VanMoof.Bike.BluetoothData`
    /// - Parameter integerValue: The integer value.
    init(
        _ integerValue: Int
    ) {
        self.init([.init(integerValue)])
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+init(challenge:crypto:)

extension VanMoof.Bike.BluetoothData {
    
    /// Creates a new instance of `VanMoof.Bike.BluetoothData`
    /// - Parameters:
    ///   - challenge: The ChallengeCharacteristic
    ///   - crypto: The BluetoothCrypto
    init(
        challenge: VanMoof.Bike.BluetoothServices.Security.ChallengeCharacteristic,
        crypto: VanMoof.Bike.BluetoothCrypto
    ) throws {
        var nonceBytes = [UInt8](repeating: 0, count: 16)
        for (index, nonceByte) in challenge.nonce.enumerated() {
            nonceBytes[index] = nonceByte
        }
        var bytes = try crypto.encrypt(bytes: nonceBytes)
        bytes.append(
            contentsOf: [0, 0, 0, .init(crypto.key.userKeyId)]
        )
        self.init(bytes)
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+addingNonce(from:)

extension VanMoof.Bike.BluetoothData {
    
    /// Add nonce from ChallengeCharacteristic
    /// - Parameter challenge: The ChallengeCharacteristic
    /// - Returns: A new BluetoothData instance
    func addingNonce(
        from challenge: VanMoof.Bike.BluetoothServices.Security.ChallengeCharacteristic
    ) -> Self {
        // Initialize byte array
        var bytes = [UInt8]()
        // Append nonce
        bytes.append(
            contentsOf: challenge.nonce
        )
        // Append data
        bytes.append(
            contentsOf: self.rawValue
        )
        // Append remaining zero bits for two bytes (16 bits)
        bytes.append(
            contentsOf: [UInt8](
                repeating: 0,
                count: Swift.max(16 - bytes.count, 0)
            )
        )
        // Return BluetoothData
        return .init(bytes)
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+integerValue

extension VanMoof.Bike.BluetoothData {
    
    /// The integer value.
    var integerValue: Int {
        .init(
            self.rawValue
                .withUnsafeBytes {
                    $0.load(as: UInt16.self)
                }
        )
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+stringValue

extension VanMoof.Bike.BluetoothData {
    
    /// The string value.
    var stringValue: String {
        .init(
            decoding: self.rawValue,
            as: UTF8.self
        )
    }
    
}
