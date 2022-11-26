import Combine
import Foundation

// MARK: - VanMoof+Bike+connect

public extension VanMoof.Bike {
    
    /// Connect to the VanMoof Bike.
    func connect() async throws {
        try await self.bluetoothManager.connect()
    }
    
}

// MARK: - VanMoof+Bike+connectionErrorPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits an error of the underlying bluetooth connection.
    var connectionErrorPublisher: AnyPublisher<Swift.Error, Never> {
        self.bluetoothManager
            .compactMap { event in
                switch event {
                case .didFailToConnectPeripheral(_ , let error):
                    return error
                case .didDisconnectPeripheral(_, let error):
                    return error
                default:
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }
    
}
