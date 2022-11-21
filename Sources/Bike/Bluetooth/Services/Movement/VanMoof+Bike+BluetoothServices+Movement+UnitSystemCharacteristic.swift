import Foundation

// MARK: - Movement+UnitSystemCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement {
    
    /// The UnitSystem Characteristic.
    struct UnitSystemCharacteristic {

        /// The UnitSystem
        let unitSystem: VanMoof.Bike.UnitSystem
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement.UnitSystemCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5533-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.unitSystem.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let unitSystem = VanMoof.Bike.UnitSystem(rawValue: data.integerValue) else {
            return nil
        }
        self.unitSystem = unitSystem
    }
    
}
