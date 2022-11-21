import Foundation

// MARK: - Movement+SpeedLimitCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement {
    
    /// The SpeedLimit Characteristic.
    struct SpeedLimitCharacteristic {
        
        /// The SpeedLimit.
        let speedLimit: VanMoof.Bike.SpeedLimit
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement.SpeedLimitCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5535-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.speedLimit.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let speedLimit = VanMoof.Bike.SpeedLimit(rawValue: data.integerValue) else {
            return nil
        }
        self.speedLimit = speedLimit
    }
    
}
