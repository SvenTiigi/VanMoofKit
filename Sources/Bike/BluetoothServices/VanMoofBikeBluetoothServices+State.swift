import Foundation

// MARK: - VanMoofBikeBluetoothServices+State

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike State Bluetooth Service
    enum State: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5560-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                ModuleModeCharacteristic.self,
                ModuleStateCharacteristic.self,
                ErrorsCharacteristic.self,
                WheelSizeCharacteristic.self,
                ClockCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - State+ModuleModeCharacteristic

extension VanMoofBikeBluetoothServices.State {
    
    /// The ModuleMode Characteristic.
    enum ModuleModeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5561-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - State+ModuleStateCharacteristic

extension VanMoofBikeBluetoothServices.State {
    
    /// The ModuleState Characteristic.
    enum ModuleStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5562-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - State+ErrorsCharacteristic

extension VanMoofBikeBluetoothServices.State {
    
    /// The Errors Characteristic.
    enum ErrorsCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5563-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - State+WheelSizeCharacteristic

extension VanMoofBikeBluetoothServices.State {
    
    /// The WheelSize Characteristic.
    enum WheelSizeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5564-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - State+ClockCharacteristic

extension VanMoofBikeBluetoothServices.State {
    
    /// The Clock Characteristic.
    enum ClockCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5567-e631-4069-944d-b8ca7598ad50"
    }
    
}
