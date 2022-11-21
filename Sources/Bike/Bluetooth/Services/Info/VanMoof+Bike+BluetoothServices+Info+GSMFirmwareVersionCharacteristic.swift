import Foundation

// MARK: - Info+GSMFirmwareVersionCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The GSMFirmwareVersion Characteristic.
    struct GSMFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        
        /// The firmware version
        let version: String

    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.GSMFirmwareVersionCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {

    /// The identifier.
    static let id: String = "6ACC554E-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.version = data.stringValue
    }
    
}
