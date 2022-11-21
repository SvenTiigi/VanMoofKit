import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Light

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Light Bluetooth Service
    enum Light: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5580-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ModeCharacteristic.self
            ]
        }
        
    }
    
}
