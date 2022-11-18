import Foundation

// MARK: - VanMoofBikeBluetoothServices+Maintenance

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Maintenance Bluetooth Service
    enum Maintenance: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc55c0-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                LogModeCharacteristic.self,
                LogSizeCharacteristic.self,
                LogBlockCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Maintenance+LogModeCharacteristic

extension VanMoofBikeBluetoothServices.Maintenance {
    
    /// The LogMode Characteristic.
    enum LogModeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc55c1-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Maintenance+LogSizeCharacteristic

extension VanMoofBikeBluetoothServices.Maintenance {
    
    /// The LogSize Characteristic.
    enum LogSizeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc55c2-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Maintenance+LogSizeCharacteristic

extension VanMoofBikeBluetoothServices.Maintenance {
    
    /// The LogBlock Characteristic.
    enum LogBlockCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc55c3-e631-4069-944d-b8ca7598ad50"
    }
    
}
