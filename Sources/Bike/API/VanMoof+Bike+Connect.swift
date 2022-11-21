import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+connect

public extension VanMoof.Bike {
    
    /// Connect to the VanMoof Bike.
    func connect() async throws {
        try await self.bluetoothManager.connect()
    }
    
}
