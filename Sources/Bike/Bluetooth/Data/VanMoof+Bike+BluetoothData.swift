import Foundation

// MARK: - VanMoof+Bike+BluetoothData

extension VanMoof.Bike {
    
    /// A VanMoof Bike Bluetooth byte buffer.
    struct BluetoothData: Codable, Hashable, Sendable {
        
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

// MARK: - VanMoof+Bike+BluetoothData+isEmpty

extension VanMoof.Bike.BluetoothData {
    
    /// A Boolean value indicating whether the data is empty.
    var isEmpty: Bool {
        self.rawValue.isEmpty
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

// MARK: - VanMoof+Bike+BluetoothData+stringValue

extension VanMoof.Bike.BluetoothData {
    
    /// The string value, if available.
    var stringValue: String? {
        // Verify data is not empty
        guard !self.isEmpty else {
            // Otherwise return nil
            return nil
        }
        // Initialize String decoding from data
        let string = String(
            decoding: self.rawValue,
            as: UTF8.self
        )
        // Return non empty string
        return string.isEmpty ? nil : string
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+integerValue

extension VanMoof.Bike.BluetoothData {
    
    /// The integer value loaded as `UInt8`, if available
    var integerValue: Int? {
        self.integerValue(as: UInt8.self)
    }
    
    /// Retrieve integer value, if available
    /// - Parameters:
    ///   - offset: The offset, in bytes, into the buffer pointer’s memory at which to begin reading data for the new instance. Default value `0`
    ///   - type: The type to use for the newly constructed instance.
    func integerValue<Number: BinaryInteger>(
        fromByteOffset offset: Int = 0,
        as type: Number.Type
    ) -> Int? {
        // Verify data is not empty
        guard !self.isEmpty else {
            // Otherwise return nil
            return nil
        }
        // Return integer value
        return .init(
            self.rawValue
                .withUnsafeBytes {
                    $0.load(
                        fromByteOffset: offset,
                        as: Number.self
                    )
                }
        )
    }
    
}

// MARK: - VanMoof+Bike+BluetoothData+parse

extension VanMoof.Bike.BluetoothData {
    
    /// Parse BluetoothData as an Integer RawRepresentable type, if available.
    /// - Parameter representable: The Integer RawRepresentable type
    /// - Returns: The RawRepresentable instance, if available.
    func parse<Representable: RawRepresentable>(
        as representable: Representable.Type = Representable.self
    ) -> Representable? where Representable.RawValue == Int {
        self.integerValue.flatMap(Representable.init)
    }
    
}
