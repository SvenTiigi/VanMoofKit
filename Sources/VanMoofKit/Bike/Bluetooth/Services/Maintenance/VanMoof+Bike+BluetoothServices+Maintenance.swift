import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Maintenance

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Maintenance Bluetooth Service
    enum Maintenance: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC55C0-E631-4069-944D-B8CA7598AD50"
        
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
