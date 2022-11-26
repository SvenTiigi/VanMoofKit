import Foundation

// MARK: - Info+ModuleBatteryStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The ModuleBatteryState Characteristic.
    struct ModuleBatteryStateCharacteristic {
        
        /// The BatteryState
        let state: VanMoof.Bike.BatteryState
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.ModuleBatteryStateCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5544-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard !data.isEmpty else {
            self.init(state: .notCharging)
            return
        }
        guard let state: VanMoof.Bike.BatteryState = data.parse() else {
            return nil
        }
        self.init(
            state: state
        )
    }
    
}
