import Combine
import Foundation

// MARK: - VanMoof+Bike+SpeedLimit

public extension VanMoof.Bike {
    
    /// A VanMoof Bike SpeedLimit
    enum SpeedLimit: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Europe (EU) | `25 km/h`
        case europe
        /// United States (US) | `32 km/h`
        case unitedStates
        /// Japan (JP) | `24 km/h`
        case japan
    }
    
}

// MARK: - VanMoof+Bike+SpeedLimit+flagEmoji

public extension VanMoof.Bike.SpeedLimit {
    
    /// The emoji flag character
    var flagEmoji: Character {
        switch self {
        case .europe:
            return "🇪🇺"
        case .unitedStates:
            return "🇺🇸"
        case .japan:
            return "🇯🇵"
        }
    }
    
}

// MARK: - VanMoof+Bike+SpeedLimit+Alias

public extension VanMoof.Bike.SpeedLimit {
    
    /// Europe (EU) | `25 km/h`
    static let eu: Self = .europe
    
    /// United States (US) | `32 km/h`
    static let us: Self = .unitedStates
    
    /// Japan (JP) | `24 km/h`
    static let jp: Self = .japan
    
}

// MARK: - VanMoof+Bike+SpeedLimit+measurement

public extension VanMoof.Bike.SpeedLimit {

    /// The measurement of the SpeedLimit
    /// - Europe: 25 km/h
    /// - United States: 32 km/h
    /// - Japan: 24 km/h
    var measurement: Measurement<UnitSpeed> {
        .init(
            value: {
                switch self {
                case .europe:
                    return 25
                case .unitedStates:
                    return 32
                case .japan:
                    return 24
                }
            }(),
            unit: .kilometersPerHour
        )
    }
    
}

// MARK: - VanMoof+Bike+speedLimit

public extension VanMoof.Bike {
    
    /// The SpeedLimit
    var speedLimit: SpeedLimit {
        get async throws {
            try await self.bluetoothManager.read(
                characteristic: BluetoothServices
                    .Movement
                    .SpeedLimitCharacteristic.self
            )
            .speedLimit
        }
    }
    
}

// MARK: - VanMoof+Bike+speedLimitPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the SpeedLimit whenever a change occurred.
    var speedLimitPublisher: AnyPublisher<SpeedLimit, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .SpeedLimitCharacteristic.self
            )
            .map(\.speedLimit)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(speedLimit:)

public extension VanMoof.Bike {
    
    /// Set SpeedLimit
    /// - Parameter speedLimit: The SpeedLimit which should be set.
    func set(
        speedLimit: SpeedLimit
    ) async throws {
        try await self.bluetoothManager.write(
            characteristic: BluetoothServices
                .Movement
                .SpeedLimitCharacteristic(
                    speedLimit: speedLimit
                )
        )
    }
    
}
