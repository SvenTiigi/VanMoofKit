import Foundation

// MARK: - Sound+PlaySoundCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound {
    
    /// A PlaySound Characteristic.
    struct PlaySoundCharacteristic {

        /// The sound
        let sound: UInt8
        
        /// The count
        let count: UInt8
        
    }
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound.PlaySoundCharacteristic: VanMoofBikeBluetoothWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5571-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init([self.sound, self.count])
    }
    
}
