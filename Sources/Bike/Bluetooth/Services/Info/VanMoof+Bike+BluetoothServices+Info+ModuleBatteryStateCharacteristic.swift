import Foundation

// MARK: - Info+ModuleBatteryStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The ModuleBatteryState Characteristic.
    enum ModuleBatteryStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6ACC5544-E631-4069-944D-B8CA7598AD50"
        #warning("ModuleBatteryStateCharacteristic | Read-Only")
    }
    
}
