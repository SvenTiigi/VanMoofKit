import Combine
import Foundation

// MARK: - VanMoof+Bike+AlarmState

public extension VanMoof.Bike {
    
    /// A VanMoof Bike AlarmState
    enum AlarmState: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Off
        case off
        /// Manual
        case manual
        /// Auto
        case auto
    }
    
}

// MARK: - VanMoof+Bike+alarmState

public extension VanMoof.Bike {
    
    /// The AlarmState
    var alarmState: AlarmState {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Defence
                        .AlarmStateCharacteristic
                        .self
                )
                .alarmState
        }
    }
    
}

// MARK: - VanMoof+Bike+alarmModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the AlarmState whenever a change occurred.
    var alarmStatePublisher: AnyPublisher<AlarmState, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Defence
                    .AlarmStateCharacteristic
                    .self
            )
            .map(\.alarmState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(alarmState:)

public extension VanMoof.Bike {
    
    /// Set AlarmState
    /// - Parameter alarmState: The AlarmState to set
    func set(
        alarmState: AlarmState
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Defence
                    .AlarmStateCharacteristic(
                        alarmState: alarmState
                    )
            )
    }
    
}
