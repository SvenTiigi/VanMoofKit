import Combine
import Foundation

// MARK: - VanMoof+Bike+SpeedLimit

public extension VanMoof.Bike {
    
    /// A VanMoof Bike SpeedLimit
    enum SpeedLimit: Int, Codable, Hashable, CaseIterable {
        /// Europe (EU) | `25 km/h`
        case europe
        /// United States (US) | `32 km/h`
        case unitedStates
        /// Japan (JP) | `24 km/h`
        case japan
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
