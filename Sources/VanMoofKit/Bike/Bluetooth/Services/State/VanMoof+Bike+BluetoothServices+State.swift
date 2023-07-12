import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+State

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike State Bluetooth Service
    enum State: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5560-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ModuleModeCharacteristic.self,
                ModuleStateCharacteristic.self,
                ErrorsCharacteristic.self,
                WheelSizeCharacteristic.self,
                ClockCharacteristic.self
            ]
        }
        
    }
    
}
