import Combine
import Foundation

// MARK: - VanMoof+Bike+Distance

public extension VanMoof.Bike {
    
    /// The distance.
    typealias Distance = Measurement<UnitLength>
    
}

// MARK: - VanMoof+Bike+totalDistance

public extension VanMoof.Bike {
    
    /// The total distance.
    var totalDistance: Distance {
        get async throws {
            .init(
                value: try await self.bluetoothManager
                    .read(
                        characteristic: BluetoothServices
                            .Movement
                            .DistanceCharacteristic.self
                    )
                    .totalDistanceInKilometers,
                unit: .kilometers
            )
        }
    }
    
}

// MARK: - VanMoof+Bike+totalDistancePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the total distance whenever a change occurred.
    var totalDistancePublisher: AnyPublisher<Distance, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .DistanceCharacteristic
                    .self
            )
            .map(\.totalDistanceInKilometers)
            .removeDuplicates()
            .map { .init(value: $0, unit: .kilometers) }
            .eraseToAnyPublisher()
    }
    
}
