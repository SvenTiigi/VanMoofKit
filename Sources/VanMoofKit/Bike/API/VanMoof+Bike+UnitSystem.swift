import Combine
import Foundation

// MARK: - VanMoof+Bike+UnitSystem

public extension VanMoof.Bike {
    
    /// A VanMoof Bike UnitSystem
    enum UnitSystem: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Metric (kilometers)
        case metric
        /// Imperial (miles)
        case imperial
    }
    
}

// MARK: - VanMoof+Bike+unitSystem

public extension VanMoof.Bike {
    
    /// The UnitSystem
    var unitSystem: UnitSystem {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Movement
                        .UnitSystemCharacteristic
                        .self
                )
                .unitSystem
        }
    }
    
}

// MARK: - VanMoof+Bike+moduleStatePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the UnitSystem whenever a change occurred.
    var unitSystemPublisher: AnyPublisher<UnitSystem, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .UnitSystemCharacteristic
                    .self
            )
            .map(\.unitSystem)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(unitSystem:)

public extension VanMoof.Bike {
    
    /// Set UnitSystem
    /// - Parameter unitSystem: The UnitSystem to set
    func set(
        unitSystem: UnitSystem
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Movement
                    .UnitSystemCharacteristic(
                        unitSystem: unitSystem
                    )
            )
    }
    
}
