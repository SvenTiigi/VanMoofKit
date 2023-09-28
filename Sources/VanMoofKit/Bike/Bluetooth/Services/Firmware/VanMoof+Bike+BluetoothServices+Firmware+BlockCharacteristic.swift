import Foundation

// MARK: - Firmware+MetadataCharacteristic

extension VanMoof.Bike.BluetoothServices.Firmware {
    
    /// The Block Characteristic.
    struct BlockCharacteristic {
        
        /// The data.
        let data: Data
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Firmware.BlockCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5512-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.data)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.init(
            data: data.rawValue
        )
    }
    
}
