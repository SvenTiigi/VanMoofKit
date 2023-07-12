import Foundation

// MARK: - Light+ModeCharacteristic

extension VanMoof.Bike.BluetoothServices.Light {
    
    /// The Mode Characteristic.
    struct ModeCharacteristic {
        
        /// The LightMode
        let lightMode: VanMoof.Bike.LightMode

    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

extension VanMoof.Bike.BluetoothServices.Light.ModeCharacteristic: VanMoofBikeBluetoothReadWritableCharacteristic {
    
    /// The identifier.
    static let id: String = "6ACC5581-E631-4069-944D-B8CA7598AD50"
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData {
        .init(self.lightMode.rawValue)
    }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData) {
        guard let lightMode: VanMoof.Bike.LightMode = data.parse() else {
            return nil
        }
        self.init(lightMode: lightMode)
    }
    
}
