import Foundation

// MARK: - Security+ChallengeCharacteristic

extension VanMoof.Bike.BluetoothServices.Security {
    
    /// The Challenge Characteristic.
    struct ChallengeCharacteristic {
        
        /// The nonce.
        let nonce: Data
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Security.ChallengeCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5501-E631-4069-944D-B8CA7598AD50"
    
    /// Bool value if data decryption is required before initializing
    /// Set to `false` as the nonce is not encrypted.
    static let isDecryptionRequired: Bool = false
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard !data.isEmpty else {
            return nil
        }
        self.init(
            nonce: data.rawValue
        )
    }
    
}
