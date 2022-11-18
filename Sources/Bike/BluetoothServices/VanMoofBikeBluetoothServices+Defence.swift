import Foundation

// MARK: - VanMoofBikeBluetoothServices+Defence

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Defence Bluetooth Service
    enum Defence: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5520-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                LockStateCharacteristic.self,
                UnlockRequestCharacteristic.self,
                AlarmStateCharacteristic.self,
                AlarmModeCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Defence+LockStateCharacteristic

extension VanMoofBikeBluetoothServices.Defence {
    
    /// The LockState Characteristic.
    enum LockStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5521-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Defence+UnlockRequestCharacteristic

extension VanMoofBikeBluetoothServices.Defence {
    
    /// The UnlockRequest Characteristic.
    enum UnlockRequestCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5522-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Defence+AlarmStateCharacteristic

extension VanMoofBikeBluetoothServices.Defence {
    
    /// The AlarmState Characteristic.
    enum AlarmStateCharacteristic: Double, VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5523-e631-4069-944d-b8ca7598ad50"
        case off = 0
        case manual = 1
        case auto = 2
    }
    
}

// MARK: - Defence+AlarmModeCharacteristic

extension VanMoofBikeBluetoothServices.Defence {
    
    /// The AlarmMode Characteristic.
    enum AlarmModeCharacteristic: Double, VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5524-e631-4069-944d-b8ca7598ad50"
        case disarmed = 0
        case armed = 1
        case one = 2
        case two = 3
        case three = 4
    }
    
}
