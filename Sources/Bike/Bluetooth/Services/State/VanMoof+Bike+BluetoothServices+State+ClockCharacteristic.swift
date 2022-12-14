import Foundation

// MARK: - State+ClockCharacteristic

extension VanMoof.Bike.BluetoothServices.State {
    
    /// The Clock Characteristic.
    struct ClockCharacteristic {
        
        /// The clock Date.
        let date: Date
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.State.ClockCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {

    /// The identifier.
    static let id: String = "6ACC5567-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let timeIntervalSince1970 = data.integerValue(as: UInt32.self) else {
            return nil
        }
        self.init(
            date: .init(
                timeIntervalSince1970: .init(timeIntervalSince1970)
            )
        )
    }
    
}
