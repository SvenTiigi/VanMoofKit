import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Firmware

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Firmware Bluetooth Service
    enum Firmware: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5510-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                MetadataCharacteristic.self,
                BlockCharacteristic.self
            ]
        }
        
    }
    
}
