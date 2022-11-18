import Foundation

// MARK: - VanMoofBikeBluetoothServices+Movement

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Movement Bluetooth Service
    enum Movement: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5530-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                DistanceCharacteristic.self,
                SpeedCharacteristic.self,
                UnitSystemCharacteristic.self,
                PowerLevelCharacteristic.self,
                SpeedLimitCharacteristic.self,
                EShifterGearCharacteristic.self,
                EShiftingPointsCharacteristic.self,
                EShifterModeCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Movement+DistanceCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The Distance Characteristic.
    struct DistanceCharacteristic: VanMoofBikeBluetoothCharacteristic, RawRepresentable {
        
        /// The identifier.
        static let id: String = "6acc5531-e631-4069-944d-b8ca7598ad50"
        
        /// The raw value
        let rawValue: Double
        
        /// Creates a new instance
        /// - Parameter rawValue: The raw value
        init?(rawValue: Double) {
            self.rawValue = rawValue
        }
        
    }
    
}

// MARK: - Movement+SpeedCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The Speed Characteristic.
    enum SpeedCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5532-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Movement+UnitSystemCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The UnitSystem Characteristic.
    enum UnitSystemCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5533-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Movement+PowerLevelCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The PowerLevel Characteristic.
    enum PowerLevelCharacteristic: Double, VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5534-e631-4069-944d-b8ca7598ad50"
        case off = 0
        case first = 1
        case second = 2
        case third = 3
        case fourth = 4
        case max = 5
    }
    
}

// MARK: - Movement+SpeedLimitCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The SpeedLimit Characteristic.
    enum SpeedLimitCharacteristic: Double, VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5535-e631-4069-944d-b8ca7598ad50"
        case europe = 0
        case unitedStates = 1
        case japan = 2
        case noLimit = 3
    }
    
}

// MARK: - Movement+EShifterGearCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The EShifterGear Characteristic.
    enum EShifterGearCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5536-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Movement+EShiftingPointsCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The EShiftingPoints Characteristic.
    enum EShiftingPointsCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5537-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Movement+EShifterModeCharacteristic

extension VanMoofBikeBluetoothServices.Movement {
    
    /// The EShifterMode Characteristic.
    enum EShifterModeCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5538-e631-4069-944d-b8ca7598ad50"
    }
    
}
