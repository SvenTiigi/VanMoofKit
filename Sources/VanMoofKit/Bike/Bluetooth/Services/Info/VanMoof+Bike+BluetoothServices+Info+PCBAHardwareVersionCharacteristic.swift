import Foundation

// MARK: - Info+PCBAHardwareVersionCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The PCBAHardwareVersion Characteristic.
    struct PCBAHardwareVersionCharacteristic {

        /// The hardware version
        let version: String
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.PCBAHardwareVersionCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC554D-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let version = data.stringValue else {
            return nil
        }
        self.init(
            version: version
        )
    }
    
}
