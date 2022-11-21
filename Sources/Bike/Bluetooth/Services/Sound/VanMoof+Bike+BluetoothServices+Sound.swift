import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Sound

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Sound Bluetooth Service
    enum Sound: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5570-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                PlaySoundCharacteristic.self,
                SoundVolumeCharacteristic.self,
                BellSoundCharacteristic.self
            ]
        }
        
    }
    
}
