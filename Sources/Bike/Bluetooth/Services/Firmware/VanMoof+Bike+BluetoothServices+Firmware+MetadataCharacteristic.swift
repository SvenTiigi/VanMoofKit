import Foundation

// MARK: - Firmware+MetadataCharacteristic

extension VanMoof.Bike.BluetoothServices.Firmware {
    
    /// The Metadata Characteristic.
    enum MetadataCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6ACC5511-E631-4069-944D-B8CA7598AD50"
    }
    
}
