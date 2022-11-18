import Foundation

// MARK: - VanMoofBikeBluetoothServices+Firmware

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Firmware Bluetooth Service
    enum Firmware: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5510-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                MetadataCharacteristic.self,
                BlockCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Firmware+MetadataCharacteristic

extension VanMoofBikeBluetoothServices.Firmware {
    
    /// The Metadata Characteristic.
    enum MetadataCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5511-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Firmware+MetadataCharacteristic

extension VanMoofBikeBluetoothServices.Firmware {
    
    /// The Block Characteristic.
    enum BlockCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5512-e631-4069-944d-b8ca7598ad50"
    }
    
}
