import Foundation

// MARK: - VanMoof+Bike+soundVolume

public extension VanMoof.Bike {
    
    /// The sound volume.
    /// Represented by an integer between `0` and `100`.
    var soundVolume: Int {
        get async throws {
            try await self.bluetoothManager.read(
                characteristic: VanMoof
                    .Bike
                    .BluetoothServices
                    .Sound
                    .SoundVolumeCharacteristic
                    .self
            )
            .soundVolume
        }
    }
    
}
