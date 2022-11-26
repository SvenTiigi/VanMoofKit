import Foundation

// MARK: - Info+MotorBatteryLevelCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The MotorBatteryLevel Characteristic.
    struct MotorBatteryLevelCharacteristic {
        
        /// The battery level
        let batteryLevel: VanMoof.Bike.BatteryLevel
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.MotorBatteryLevelCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5541-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let batteryLevel = data.integerValue else {
            return nil
        }
        self.init(
            batteryLevel: .init(batteryLevel)
        )
    }
    
}
