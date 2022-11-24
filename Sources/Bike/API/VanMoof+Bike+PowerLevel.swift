import Combine
import Foundation

// MARK: - VanMoof+Bike+PowerLevel

public extension VanMoof.Bike {
    
    /// A VanMoof Bike PowerLevel
    enum PowerLevel: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Off
        case off
        /// Level 1
        case one
        /// Level 2
        case two
        /// Level 3
        case three
        /// Level 4
        case four
        /// Maximum (Level 5)
        case maximum
    }
    
}

// MARK: - VanMoof+Bike+PowerLevel+Alias

public extension VanMoof.Bike.PowerLevel {
    
    /// Zero (Off)
    static let zero: Self = .off
    
    /// Maximum (Level 5)
    static let max: Self = .maximum
    
    /// Maximum (Level 5)
    static let five: Self = .maximum
    
}

// MARK: - VanMoof+Bike+powerLevel

public extension VanMoof.Bike {
    
    /// The PowerLevel
    var powerLevel: PowerLevel {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Movement
                        .PowerLevelCharacteristic
                        .self
                )
                .powerLevel
        }
    }
    
}

// MARK: - VanMoof+Bike+powerLevelPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the PowerLevel whenever a change occurred.
    var powerLevelPublisher: AnyPublisher<PowerLevel, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .PowerLevelCharacteristic
                    .self
            )
            .map(\.powerLevel)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(powerLevel:)

public extension VanMoof.Bike {
    
    /// Set PowerLevel
    /// - Parameter powerLevel: The PowerLevel to set
    func set(
        powerLevel: PowerLevel
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Movement
                    .PowerLevelCharacteristic(
                        powerLevel: powerLevel
                    )
            )
    }
    
}
