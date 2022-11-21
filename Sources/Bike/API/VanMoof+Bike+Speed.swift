import Combine
import Foundation

// MARK: - VanMoof+Bike+Speed

public extension VanMoof.Bike {
    
    /// The speed of a bike measured in kilometers per hour `km/h`.
    typealias Speed = Int
    
}

// MARK: - VanMoof+Bike+speed

public extension VanMoof.Bike {
    
    /// The current Speed
    var speed: Speed {
        get async throws {
            return try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Movement
                        .SpeedCharacteristic
                        .self
                )
                .speed
        }
    }
    
}

// MARK: - VanMoof+Bike+alarmModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the current Speed.
    var speedPublisher: AnyPublisher<Speed, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .SpeedCharacteristic
                    .self
            )
            .map(\.speed)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}
