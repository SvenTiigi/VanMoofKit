import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Defence

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Defence Bluetooth Service
    enum Defence: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5520-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                LockStateCharacteristic.self,
                UnlockRequestCharacteristic.self,
                AlarmStateCharacteristic.self,
                AlarmModeCharacteristic.self
            ]
        }
        
    }
    
}
