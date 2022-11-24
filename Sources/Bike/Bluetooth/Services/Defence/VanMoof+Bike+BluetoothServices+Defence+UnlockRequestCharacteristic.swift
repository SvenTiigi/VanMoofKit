import Foundation

// MARK: - Defence+UnlockRequestCharacteristic

extension VanMoof.Bike.BluetoothServices.Defence {
    
    /// The UnlockRequest Characteristic.
    enum UnlockRequestCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6ACC5522-E631-4069-944D-B8CA7598AD50"
        #warning("UnlockRequestCharacteristic | Read-Only")
    }
    
}
