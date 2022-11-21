import Combine
import Foundation

// MARK: - VanMoof+Bike+ModuleState

public extension VanMoof.Bike {
    
    /// A VanMoof Bike ModuleState
    enum ModuleState: Int, Codable, Hashable, CaseIterable {
        /// On
        case on
        /// Off
        case off
        /// Shipping
        case shipping
        /// Standby
        case standby
        /// Alarm one
        case alarmOne
        /// Alarm two
        case alarmTwo
        /// Alarm three
        case alarmThree
        /// Sleeping
        case sleeping
        /// Tracking
        case tracking
    }
    
}

// MARK: - VanMoof+Bike+moduleState

public extension VanMoof.Bike {
    
    /// The ModuleState
    var moduleState: ModuleState {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .State
                        .ModuleStateCharacteristic
                        .self
                )
                .moduleState
        }
    }
    
}

// MARK: - VanMoof+Bike+moduleStatePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the ModuleState whenever a change occurred.
    var moduleStatePublisher: AnyPublisher<ModuleState, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .State
                    .ModuleStateCharacteristic
                    .self
            )
            .map(\.moduleState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(moduleState:)

public extension VanMoof.Bike {
    
    /// Set ModuleState
    /// - Parameter moduleState: The ModuleState to set
    func set(
        moduleState: ModuleState
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .State
                    .ModuleStateCharacteristic(
                        moduleState: moduleState
                    )
            )
    }
    
}
