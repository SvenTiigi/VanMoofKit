import Foundation

// MARK: - Defence+LockStateCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence {
    
    /// The LockState Characteristic.
    struct LockStateCharacteristic {

        /// The LockState
        let lockState: VanMoof.Bike.LockState
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence.LockStateCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5521-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.lockState.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let lockState: VanMoof.Bike.LockState = data.parse() else {
            return nil
        }
        self.init(
            lockState: lockState
        )
    }
    
}
