import Foundation

// MARK: - Sound+SoundVolumeCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound {
    
    /// A SoundVolume Characteristic.
    struct SoundVolumeCharacteristic {
        
        /// The sound volume
        let soundVolume: Int
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound.SoundVolumeCharacteristic: VanMoofBikeBluetoothReadableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5572-E631-4069-944D-B8CA7598AD50"
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        self.soundVolume = data.integerValue
    }
    
}
