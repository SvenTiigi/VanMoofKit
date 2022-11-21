import Foundation

// MARK: - Security+KeyIndexCharacteristic

extension VanMoof.Bike.BluetoothServices.Security {
    
    /// The KeyIndex Characteristic.
    struct KeyIndexCharacteristic {
        
        // MARK: Properties
        
        /// The writable bluetooth data.
        let writableData: VanMoof.Bike.BluetoothData
        
        // MARK: Initializer
        
        /// Creates a new instance of `KeyIndexCharacteristic`
        /// - Parameters:
        ///   - challenge: The ChallengeCharacteristic
        ///   - crypto: The VanMoof Bike BluetoothCrypto.
        init(
            challenge: ChallengeCharacteristic,
            crypto: VanMoof.Bike.BluetoothCrypto
        ) throws {
            self.writableData = try .init(
                challenge: challenge,
                crypto: crypto
            )
        }
        
    }
    
}

// MARK: - VanMoofBikeBluetoothWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Security.KeyIndexCharacteristic: VanMoofBikeBluetoothWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5502-E631-4069-944D-B8CA7598AD50"
    
    /// Bool value if data encryption is required.
    static var isEncryptionRequired: Bool = false
    
}
