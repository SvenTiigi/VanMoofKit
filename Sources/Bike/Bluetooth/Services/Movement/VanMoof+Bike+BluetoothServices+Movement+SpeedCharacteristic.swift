import Foundation

// MARK: - Movement+SpeedCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement {
    
    /// The Speed Characteristic.
    struct SpeedCharacteristic {
        
        /// The speed in kilometers per hour
        let speed: Int

    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement.SpeedCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5532-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let speed = data.integerValue else {
            return nil
        }
        self.init(
            speed: speed
        )
    }
    
}
