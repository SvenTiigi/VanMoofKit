import Foundation

// MARK: - Defence+AlarmModeCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence {
    
    /// The AlarmMode Characteristic.
    struct AlarmModeCharacteristic {

        /// The AlarmMode
        let alarmMode: VanMoof.Bike.AlarmMode
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence.AlarmModeCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5524-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.alarmMode.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let alarmMode = VanMoof.Bike.AlarmMode(rawValue: data.integerValue) else {
            return nil
        }
        self.alarmMode = alarmMode
    }
    
}
