import Foundation

// MARK: - VanMoofBikeBluetoothServices+Security

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Security Bluetooth Service
    enum Security: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5500-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ChallengeCharacteristic.self,
                KeyIndexCharacteristic.self,
                BackupCodeCharacteristic.self,
                BikeMessageCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Security+ChallengeCharacteristic

extension VanMoofBikeBluetoothServices.Security {
    
    /// The Challenge Characteristic.
    enum ChallengeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5501-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Security+KeyIndexCharacteristic

extension VanMoofBikeBluetoothServices.Security {
    
    /// The KeyIndex Characteristic.
    enum KeyIndexCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5502-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Security+BackupCodeCharacteristic

extension VanMoofBikeBluetoothServices.Security {
    
    /// The BackupCode Characteristic.
    enum BackupCodeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5503-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Security+BackupCodeCharacteristic

extension VanMoofBikeBluetoothServices.Security {
    
    /// The BikeMessage Characteristic.
    enum BikeMessageCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5505-e631-4069-944d-b8ca7598ad50"
    }
    
}
