import Combine
import Foundation

// MARK: - VanMoof+Bike+communicationErrorPublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits any kind of error which occurred in the underlying bluetooth communication.
    var communicationErrorPublisher: AnyPublisher<Swift.Error, Never> {
        self.bluetoothManager
            .compactMap(\.error)
            .eraseToAnyPublisher()
    }
    
}
