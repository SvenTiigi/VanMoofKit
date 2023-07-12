import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Info

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Info Bluetooth Service
    enum Info: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5540-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                MotorBatteryLevelCharacteristic.self,
                MotorBatteryStateCharacteristic.self,
                ModuleBatteryLevelCharacteristic.self,
                ModuleBatteryStateCharacteristic.self,
                BikeFirmwareVersionCharacteristic.self,
                BLEChipFirmwareVersionCharacteristic.self,
                ControllerFirmwareVersionCharacteristic.self,
                PCBAHardwareVersionCharacteristic.self,
                GSMFirmwareVersionCharacteristic.self,
                EShifterFirmwareVersionCharacteristic.self,
                BatteryFirmwareVersionCharacteristic.self
            ]
        }
        
    }
    
}
