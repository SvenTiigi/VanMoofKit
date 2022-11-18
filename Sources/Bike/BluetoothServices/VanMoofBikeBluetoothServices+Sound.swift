import Foundation

// MARK: - VanMoofBikeBluetoothServices+Sound

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Sound Bluetooth Service
    enum Sound: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5570-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                PlaySoundCharacteristic.self,
                SoundVolumeCharacteristic.self,
                BellSoundCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Sound+PlaySoundCharacteristic

extension VanMoofBikeBluetoothServices.Sound {
    
    /// A PlaySound Characteristic.
    enum PlaySoundCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5571-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Sound+SoundVolumeCharacteristic

extension VanMoofBikeBluetoothServices.Sound {
    
    /// A SoundVolume Characteristic.
    struct SoundVolumeCharacteristic: VanMoofBikeBluetoothCharacteristic, RawRepresentable {
        
        /// The identifier.
        static let id: String = "6acc5572-e631-4069-944d-b8ca7598ad50"
        
        /// The raw value
        let rawValue: Double
        
        /// Creates a new instance
        /// - Parameter rawValue: The raw value
        init?(rawValue: Double) {
            self.rawValue = rawValue
        }
        
    }
    
}

// MARK: - Sound+BellSoundCharacteristic

extension VanMoofBikeBluetoothServices.Sound {
    
    /// A BellSound Characteristic.
    enum BellSoundCharacteristic: Double, VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5574-e631-4069-944d-b8ca7598ad50"
        case bell = 0x16
        case sonar = 0x0a
        case party = 0x17
        case foghorn = 0x18
    }
    
}
