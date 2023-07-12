import Foundation

// MARK: - VanMoof+Bike+batteryFirmwareVersion

public extension VanMoof.Bike {
    
    /// The battery firmware version.
    var batteryFirmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .BatteryFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+firmwareVersion

public extension VanMoof.Bike {
    
    /// The bike firmware version.
    var firmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .BikeFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+bleChipFirmwareVersion

public extension VanMoof.Bike {
    
    /// The BLE chip firmware version.
    var bleChipFirmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .BLEChipFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+controllerFirmwareVersion

public extension VanMoof.Bike {
    
    /// The controller firmware version.
    var controllerFirmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .ControllerFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+eShifterFirmwareVersion

public extension VanMoof.Bike {
    
    /// The E-Shifter firmware version.
    var eShifterFirmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .EShifterFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+gsmFirmwareVersion

public extension VanMoof.Bike {
    
    /// The GSM firmware version.
    var gsmFirmwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .GSMFirmwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}

// MARK: - VanMoof+Bike+pcbaHardwareVersion

public extension VanMoof.Bike {
    
    /// The Printed Circuit Board Assembly (PCBA) hardware version.
    var pcbaHardwareVersion: String {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .PCBAHardwareVersionCharacteristic.self
                )
                .version
        }
    }
    
}
