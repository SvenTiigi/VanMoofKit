import Foundation

// MARK: - VanMoof+Bike+clockDate

public extension VanMoof.Bike {
    
    /// The clock Date.
    var clockDate: Date {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .State
                        .ClockCharacteristic
                        .self
                )
                .date
        }
    }
    
}
