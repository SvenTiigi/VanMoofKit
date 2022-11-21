import Foundation

// MARK: - Info+BikeFirmwareVersionCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The BikeFirmwareVersion Characteristic.
    struct BikeFirmwareVersionCharacteristic {
        
        /// The firmware version.
        let version: String

    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.BikeFirmwareVersionCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC554A-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.version = data.stringValue
    }
    
}
