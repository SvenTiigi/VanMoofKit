import Foundation

// MARK: - Defence+AlarmStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence {
    
    /// The AlarmState Characteristic.
    struct AlarmStateCharacteristic {

        /// The AlarmState
        let alarmState: VanMoof.Bike.AlarmState
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence.AlarmStateCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5523-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.alarmState.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let alarmState: VanMoof.Bike.AlarmState = data.parse() else {
            return nil
        }
        self.init(
            alarmState: alarmState
        )
    }
    
}
