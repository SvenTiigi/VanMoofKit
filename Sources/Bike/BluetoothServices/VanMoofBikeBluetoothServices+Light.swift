import Foundation

// MARK: - VanMoofBikeBluetoothServices+Light

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Light Bluetooth Service
    enum Light: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5580-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ModeCharacteristic.self
            ]
        }
        
    }
    
}


// MARK: - Light+ModeCharacteristic

extension VanMoofBikeBluetoothServices.Light {
    
    /// The Mode Characteristic.
    enum ModeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5581-e631-4069-944d-b8ca7598ad50"
    }
    
}
