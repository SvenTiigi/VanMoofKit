import Foundation

// MARK: - Info+MotorBatteryStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The MotorBatteryState Characteristic.
    struct MotorBatteryStateCharacteristic {
        
        /// The BatteryState
        let state: VanMoof.Bike.BatteryState
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.MotorBatteryStateCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5542-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let state: VanMoof.Bike.BatteryState = data.parse() else {
            return nil
        }
        self.init(
            state: state
        )
    }
    
}
