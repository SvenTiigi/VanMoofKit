import Combine
import Foundation

// MARK: - VanMoof+Bike+LockState

public extension VanMoof.Bike {
    
    /// A VanMoof Bike LockState
    enum LockState: Int, Codable, Hashable, CaseIterable {
        /// Unlocked
        case unlocked
        /// Locked
        case locked
        /// Awaiting Unlock
        case awaitingUnlock
    }
    
}

// MARK: - VanMoof+Bike+lockState

public extension VanMoof.Bike {
    
    /// The LockState
    var lockState: LockState {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Defence
                        .LockStateCharacteristic
                        .self
                )
                .lockState
        }
    }
    
}

// MARK: - VanMoof+Bike+alarmModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the LockState whenever a change occurred.
    var lockStatePublisher: AnyPublisher<LockState, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Defence
                    .LockStateCharacteristic
                    .self
            )
            .map(\.lockState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(lockState:)

public extension VanMoof.Bike {
    
    /// Set LockState
    /// - Parameter lockState: The LockState to set
    func set(
        lockState: LockState
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Defence
                    .LockStateCharacteristic(
                        lockState: lockState
                    )
            )
    }
    
}
