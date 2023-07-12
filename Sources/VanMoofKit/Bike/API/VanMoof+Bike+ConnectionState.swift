import Combine
import Foundation

// MARK: - VanMoof+Bike+ConnectionState

public extension VanMoof.Bike {
    
    /// A VanMoof Bike ConnectionState
    enum ConnectionState: String, Codable, Hashable, CaseIterable, Sendable {
        /// Disconnected
        case disconnected
        /// Discovering
        case discovering
        /// Connecting
        case connecting
        /// Connecting
        case connected
        /// Disconnecting
        case disconnecting
    }
    
}

// MARK: - VanMoof+Bike+connectionState

public extension VanMoof.Bike {
    
    /// The connection state.
    var connectionState: ConnectionState {
        if self.bluetoothManager.central.isScanning {
            return .discovering
        }
        switch self.bluetoothManager.peripheral?.state {
        case nil, .disconnected:
            return .disconnected
        case .disconnecting:
            return .disconnecting
        case .connecting:
            return .connecting
        case .connected:
            return self.bluetoothManager.isPeripheralAuthenticated ? .connected : .connecting
        default:
            return .disconnected
        }
    }
    
}

// MARK: - VanMoof+Bike+connectionStatePublisher

public extension VanMoof.Bike {
    
    /// A Publisher that emits the current ConnectionState and continue emitting whenever a change occurred.
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
        Just(
            self.connectionState
        )
        .merge(
            with: self.objectWillChange
                .compactMap { [weak self] in
                    self?.connectionState
                }
        )
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
}

// MARK: - VanMoof+Bike+isDisconnected

public extension VanMoof.Bike {
    
    /// Bool value if VanMoof Bike connection state is disconnected.
    var isDisconnected: Bool {
        self.connectionState == .disconnected
    }
    
}

// MARK: - VanMoof+Bike+isDiscovering

public extension VanMoof.Bike {
    
    /// Bool value if VanMoof Bike connection state is discovering.
    var isDiscovering: Bool {
        self.connectionState == .discovering
    }
    
}

// MARK: - VanMoof+Bike+isConnecting

public extension VanMoof.Bike {
    
    /// Bool value if VanMoof Bike connection state is connecting.
    var isConnecting: Bool {
        self.connectionState == .connecting
    }
    
}

// MARK: - VanMoof+Bike+isConnected

public extension VanMoof.Bike {
    
    /// Bool value if VanMoof Bike connection state is connected.
    var isConnected: Bool {
        self.connectionState == .connected
    }
    
}

// MARK: - VanMoof+Bike+isDisconnecting

public extension VanMoof.Bike {
    
    /// Bool value if VanMoof Bike connection state is disconnecting.
    var isDisconnecting: Bool {
        self.connectionState == .disconnecting
    }
    
}
