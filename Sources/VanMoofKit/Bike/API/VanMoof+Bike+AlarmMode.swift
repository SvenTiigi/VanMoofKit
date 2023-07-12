import Combine
import Foundation

// MARK: - VanMoof+Bike+AlarmMode

public extension VanMoof.Bike {
    
    /// A VanMoof Bike AlarmMode
    enum AlarmMode: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Disarmed
        case disarmed = 0
        /// Armed
        case armed = 1
        /// First Mode
        case one = 2
        /// Second Mode
        case two = 3
        /// Third Mode
        case three = 4
    }
    
}

// MARK: - VanMoof+Bike+alarmMode

public extension VanMoof.Bike {
    
    /// The AlarmMode
    var alarmMode: AlarmMode {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Defence
                        .AlarmModeCharacteristic
                        .self
                )
                .alarmMode
        }
    }
    
}

// MARK: - VanMoof+Bike+alarmModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the AlarmMode whenever a change occurred.
    var alarmModePublisher: AnyPublisher<AlarmMode, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Defence
                    .AlarmModeCharacteristic
                    .self
            )
            .map(\.alarmMode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(alarmMode:)

public extension VanMoof.Bike {
    
    /// Set AlarmMode
    /// - Parameter alarmMode: The AlarmMode to set
    func set(
        alarmMode: AlarmMode
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Defence
                    .AlarmModeCharacteristic(
                        alarmMode: alarmMode
                    )
            )
    }
    
}
