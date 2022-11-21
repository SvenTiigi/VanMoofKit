import Foundation

// MARK: - Movement+DistanceCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement {
    
    /// The Distance Characteristic.
    struct DistanceCharacteristic {
        
        /// The total distance in kilometers
        let totalDistanceInKilometers: Int

    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Movement.DistanceCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5531-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.totalDistanceInKilometers = data.integerValue / 10
    }
    
}
