import Foundation

// MARK: - State+ModuleStateCharacteristic

extension VanMoof.Bike.BluetoothServices.State {
    
    /// The ModuleState Characteristic.
    struct ModuleStateCharacteristic {

        /// The ModuleState
        let moduleState: VanMoof.Bike.ModuleState
        
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.State.ModuleStateCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5562-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.moduleState.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let moduleState: VanMoof.Bike.ModuleState = data.parse() else {
            return nil
        }
        self.init(moduleState: moduleState)
    }
    
}
