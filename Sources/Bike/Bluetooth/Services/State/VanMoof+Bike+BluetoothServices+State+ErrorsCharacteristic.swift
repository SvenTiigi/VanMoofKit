import Foundation

// MARK: - State+ErrorsCharacteristic

extension VanMoof.Bike.BluetoothServices.State {
    
    /// The Errors Characteristic.
    struct ErrorsCharacteristic {

        /// The ErrorCode
        let errorCode: VanMoof.Bike.ErrorCode
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.State.ErrorsCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5563-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.errorCode = .init(code: data.integerValue)
    }
    
}
