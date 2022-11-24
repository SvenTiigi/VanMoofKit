import Foundation

// MARK: - Info+MotorBatteryStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The MotorBatteryState Characteristic.
    enum MotorBatteryStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6ACC5542-E631-4069-944D-B8CA7598AD50"
        #warning("MotorBatteryStateCharacteristic | Read Only")
    }
    
}
