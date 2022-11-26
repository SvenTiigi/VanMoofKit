import Foundation

// MARK: - Info+ModuleBatteryLevelCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The ModuleBatteryLevel Characteristic.
    struct ModuleBatteryLevelCharacteristic {

        /// The battery level
        let batteryLevel: Int
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.ModuleBatteryLevelCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5543-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.batteryLevel = data.integerValue
    }
    
}
