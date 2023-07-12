import Foundation

// MARK: - VanMoof+Bike+disconnect

public extension VanMoof.Bike {
    
    /// Disconnect from VanMoof Bike.
    func disconnect() async throws {
        try await self.bluetoothManager.disconnect()
    }
    
}
