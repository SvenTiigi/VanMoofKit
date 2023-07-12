import Combine
import Foundation

// MARK: - VanMoof+Bike+BatteryState

public extension VanMoof.Bike {
    
    /// A VanMoof Bike BatteryState
    enum BatteryState: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Not charging
        case notCharging
        /// Charging
        case charging
    }
    
}

// MARK: - VanMoof+Bike+BatteryState+isCharging

public extension VanMoof.Bike.BatteryState {
    
    /// A Bool value if the BatteryState is set to `.charging`
    var isCharging: Bool {
        switch self {
        case .notCharging:
            return false
        case .charging:
            return true
        }
    }
    
}

// MARK: - VanMoof+Bike+batteryState

public extension VanMoof.Bike {
    
    /// The motor battery state.
    var batteryState: BatteryState {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .MotorBatteryStateCharacteristic
                        .self
                )
                .state
        }
    }
    
}

// MARK: - VanMoof+Bike+lightModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the motor battery state whenever a change occurred.
    var batteryStatePublisher: AnyPublisher<BatteryState, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Info
                    .MotorBatteryStateCharacteristic
                    .self
            )
            .map(\.state)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+moduleBatteryState

public extension VanMoof.Bike {
    
    /// The module battery state.
    var moduleBatteryState: BatteryState {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Info
                        .ModuleBatteryStateCharacteristic
                        .self
                )
                .state
        }
    }
    
}

// MARK: - VanMoof+Bike+moduleBatteryStatePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the module battery state whenever a change occurred.
    var moduleBatteryStatePublisher: AnyPublisher<BatteryState, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Info
                    .ModuleBatteryStateCharacteristic
                    .self
            )
            .map(\.state)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}
