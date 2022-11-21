import Combine
import Foundation

// MARK: - VanMoof+Bike+LightMode

public extension VanMoof.Bike {
    
    /// A VanMoof Bike LightMode
    enum LightMode: Int, Codable, Hashable, CaseIterable {
        /// Auto
        case auto
        /// Always on
        case alwaysOn
        /// Off
        case off
        /// Rear flash
        case rearFlash
        /// Rear flash stopped
        case rearFlashStopped
    }
    
}

// MARK: - VanMoof+Bike+lightMode

public extension VanMoof.Bike {
    
    /// The LightMode
    var lightMode: LightMode {
        get async throws {
            try await self.bluetoothManager
                .read(
                    characteristic: BluetoothServices
                        .Light
                        .ModeCharacteristic
                        .self
                )
                .lightMode
        }
    }
    
}

// MARK: - VanMoof+Bike+lightModePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the LightMode whenever a change occurred.
    var lightModePublisher: AnyPublisher<LightMode, Never> {
        self.bluetoothManager
            .publisher(
                for: BluetoothServices
                    .Light
                    .ModeCharacteristic
                    .self
            )
            .map(\.lightMode)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+set(alarmState:)

public extension VanMoof.Bike {
    
    /// Set LightMode
    /// - Parameter lightMode: The LightMode to set
    func set(
        lightMode: LightMode
    ) async throws {
        try await self.bluetoothManager
            .write(
                characteristic: BluetoothServices
                    .Light
                    .ModeCharacteristic(
                        lightMode: lightMode
                    )
            )
    }
    
}

