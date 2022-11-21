import Foundation

// MARK: - VanMoof+Bike+BluetoothServices+Security

extension VanMoof.Bike.BluetoothServices {
    
    /// The VanMoof Bike Security Bluetooth Service
    enum Security: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6ACC5500-E631-4069-944D-B8CA7598AD50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ChallengeCharacteristic.self,
                KeyIndexCharacteristic.self,
                BackupCodeCharacteristic.self,
                BikeMessageCharacteristic.self
            ]
        }
        
    }
    
}
