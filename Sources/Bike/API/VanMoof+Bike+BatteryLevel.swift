import Combine
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

// MARK: - VanMoof+Bike+batteryLevelPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the battery level whenever a change occurred.
    var batteryLevelPublisher: AnyPublisher<Int, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Info
                    .MotorBatteryLevelCharacteristic
                    .self
            )
            .map(\.batteryLevel)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}
