import Combine
import Foundation

// MARK: - VanMoof+Bike+Speed

public extension VanMoof.Bike {
    
    /// The speed of a bike.
    typealias Speed = Measurement<UnitSpeed>
    
}

// MARK: - VanMoof+Bike+speed

public extension VanMoof.Bike {
    
    /// The current Speed
    var speed: Speed {
        get async throws {
            .init(
                value: .init(
                    try await self.bluetoothManager
                        .read(
                            characteristic: BluetoothServices
                                .Movement
                                .SpeedCharacteristic
                                .self
                        )
                        .speed
                ),
                unit: .kilometersPerHour
            )
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
            .map { .init(value: .init($0), unit: .kilometersPerHour) }
            .eraseToAnyPublisher()
    }
    
}
