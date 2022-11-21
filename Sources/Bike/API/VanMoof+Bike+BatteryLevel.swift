import Foundation

// MARK: - VanMoof+Bike+batteryLevel

public extension VanMoof.Bike {
    
    /// The battery level.
    /// Represented by an integer between `0` and `100`
    var batteryLevel: Int {
        get async throws {
            try await self.bluetoothManager.read(
                characteristic: BluetoothServices
                    .Info
                    .MotorBatteryLevelCharacteristic
                    .self
            )
            .batteryLevel
        }
    }
    
}
