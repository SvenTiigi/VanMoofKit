import Foundation

// MARK: - VanMoofBikeBluetoothServices+Info

extension VanMoofBikeBluetoothServices {
    
    /// The VanMoof Bike Info Bluetooth Service
    enum Info: VanMoofBikeBluetoothService {
        
        /// The identifier.
        static let id = "6acc5540-e631-4069-944d-b8ca7598ad50"
        
        /// The characteristics.
        static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] {
            [
                MotorBatteryLevelCharacteristic.self,
                MotorBatteryStateCharacteristic.self,
                ModuleBatteryLevelCharacteristic.self,
                ModuleBatteryStateCharacteristic.self,
                BikeFirmwareVersionCharacteristic.self,
                BLEChipFirmwareVersionCharacteristic.self,
                ControllerFirmwareVersionCharacteristic.self,
                PCBAHardwareVersionCharacteristic.self,
                GSMFirmwareVersionCharacteristic.self,
                EShifterFirmwareVersionCharacteristic.self,
                BatteryFirmwareVersionCharacteristic.self
            ]
        }
        
    }
    
}

// MARK: - Info+MotorBatteryLevelCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The MotorBatteryLevel Characteristic.
    struct MotorBatteryLevelCharacteristic: VanMoofBikeBluetoothCharacteristic, RawRepresentable {
        
        /// The identifier.
        static let id: String = "6acc5541-e631-4069-944d-b8ca7598ad50"
        
        /// The raw value
        let rawValue: Double
        
        /// Creates a new instance
        /// - Parameter rawValue: The raw value
        init?(rawValue: Double) {
            self.rawValue = rawValue
        }
        
    }
    
}

// MARK: - Info+MotorBatteryStateCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The MotorBatteryState Characteristic.
    enum MotorBatteryStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5542-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+ModuleBatteryLevelCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The ModuleBatteryLevel Characteristic.
    enum ModuleBatteryLevelCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5543-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+ModuleBatteryStateCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The ModuleBatteryState Characteristic.
    enum ModuleBatteryStateCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5544-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+BikeFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The BikeFirmwareVersion Characteristic.
    enum BikeFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554a-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+BLEChipFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The BLEChipFirmwareVersion Characteristic.
    enum BLEChipFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554b-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+ControllerFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The ControllerFirmwareVersion Characteristic.
    enum ControllerFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554c-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+PCBAHardwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The PCBAHardwareVersion Characteristic.
    enum PCBAHardwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554d-e631-4069-944d-b8ca7598ad50"
    }
    
}


// MARK: - Info+GSMFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The GSMFirmwareVersion Characteristic.
    enum GSMFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554e-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+EShifterFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The EShifterFirmwareVersion Characteristic.
    enum EShifterFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc554f-e631-4069-944d-b8ca7598ad50"
    }
    
}

// MARK: - Info+BatteryFirmwareVersionCharacteristic

extension VanMoofBikeBluetoothServices.Info {
    
    /// The BatteryFirmwareVersion Characteristic.
    enum BatteryFirmwareVersionCharacteristic: VanMoofBikeBluetoothCharacteristic {
        /// The identifier.
        static let id: String = "6acc5550-e631-4069-944d-b8ca7598ad50"
    }
    
}
