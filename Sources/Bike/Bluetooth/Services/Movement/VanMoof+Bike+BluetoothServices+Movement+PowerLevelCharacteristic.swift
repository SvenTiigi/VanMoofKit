import Foundation

// MARK: - Movement+PowerLevelCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement {
    
    /// The PowerLevel Characteristic.
    struct PowerLevelCharacteristic {
        
        /// The PowerLevel
        let powerLevel: VanMoof.Bike.PowerLevel

    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement.PowerLevelCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5534-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.powerLevel.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let powerLevel = VanMoof.Bike.PowerLevel(rawValue: data.integerValue) else {
            return nil
        }
        self.powerLevel = powerLevel
    }
    
}
