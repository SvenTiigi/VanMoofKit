import Foundation

// MARK: - Info+BLEChipFirmwareVersionCharacteristic

extension VanMoof.Bike.BluetoothServices.Info {
    
    /// The BLEChipFirmwareVersion Characteristic.
    struct BLEChipFirmwareVersionCharacteristic {
        
        /// The firmware version
        let version: String
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Info.BLEChipFirmwareVersionCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC554B-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.version = data.stringValue
    }
    
}
