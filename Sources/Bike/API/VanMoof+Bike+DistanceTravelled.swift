import Combine
import Foundation

// MARK: - VanMoof+Bike+totalDistance

public extension VanMoof.Bike {
    
    /// The total distance in kilometers
    var totalDistance: Int {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Movement
                        .DistanceCharacteristic.self
                )
                .totalDistanceInKilometers
        }
    }
    
}

// MARK: - VanMoof+Bike+totalDistancePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the total distance whenever a change occurred.
    var totalDistancePublisher: AnyPublisher<Int, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Movement
                    .DistanceCharacteristic
                    .self
            )
            .map(\.totalDistanceInKilometers)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}
