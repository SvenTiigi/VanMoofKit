import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Movement

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Movement Bluetooth Service
    enum Movement: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5530-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                DistanceCharacteristic.self,
                SpeedCharacteristic.self,
                UnitSystemCharacteristic.self,
                PowerLevelCharacteristic.self,
                SpeedLimitCharacteristic.self,
                EShifterGearCharacteristic.self,
                EShiftingPointsCharacteristic.self,
                EShifterModeCharacteristic.self
            ]
        }
        
    }
    
}
