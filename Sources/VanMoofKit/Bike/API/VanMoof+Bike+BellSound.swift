import Combine
import Foundation

// MARK: - VanMoof+Bike+BellSound

public extension VanMoof.Bike {
    
    /// A VanMoof Bike BellSound
    enum BellSound: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Sonar
        case sonar = 10
        /// Bell
        case bell = 22
        /// Party
        case party = 23
        /// Foghorn
        case foghorn = 24
    }
    
}

// MARK: - VanMoof+Bike+bellSound

public extension VanMoof.Bike {
    
    /// The BellSound
    var bellSound: BellSound {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Sound
                        .BellSoundCharacteristic.self
                )
                .bellSound
        }
    }
    
}

// MARK: - VanMoof+Bike+bellSoundPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the BellSound whenever a change occurred.
    var bellSoundPublisher: AnyPublisher<BellSound, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Sound
                    .BellSoundCharacteristic.self
            )
            .map(\.bellSound)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(bellSound:)

public extension VanMoof.Bike {
    
    /// Set BellSound
    /// - Parameter bellSound: The BellSound to set
    func set(
        bellSound: BellSound
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Sound
                    .BellSoundCharacteristic(
                        bellSound: bellSound
                    )
            )
    }
    
}
