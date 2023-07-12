import Foundation

// MARK: - Sound+BellSoundCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound {
    
    /// A BellSound Characteristic.
    struct BellSoundCharacteristic {

        /// The BellSound
        let bellSound: VanMoof.Bike.BellSound
        
    }
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic

extension VanMoof.Bike.BluetoothServices.Sound.BellSoundCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5574-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.bellSound.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let bellSound: VanMoof.Bike.BellSound = data.parse() else {
            return nil
        }
        self.init(
            bellSound: bellSound
        )
    }
    
}
