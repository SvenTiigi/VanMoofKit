import Combine
import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike

public extension VanMoof {
    
    /// A VanMoof Bike
    @dynamicMemberLookup
    final class Bike: ObservableObject {
        
        // MARK: Properties
        
        /// The details of the bike.
        public let details: Details
        
        /// The BluetoothManager
        lazy var bluetoothManager: BluetoothManager = self.makeBluetoothManager()
        
        /// The subscriptions.
        private var cancellables = Set<AnyCancellable>()
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike`
        /// - Parameters:
        ///   - details: The details of the Bike.
        public init(
            details: Details
        ) {
            self.details = details
        }
        
    }
    
}

// MARK: - Make BluetoothManager

private extension VanMoof.Bike {
    
    /// Creates an instance of `BluetoothManager`
    func makeBluetoothManager() -> BluetoothManager {
        // Initialize BluetoothManager
        let bluetoothManager = BluetoothManager(
            details: self.details
        )
        // Subscribe to events
        bluetoothManager
            .sink { event in
                // Switch on event
                switch event {
                case .didDisconnectPeripheral(_, let error):
                    // Verify auto reconnect is enabled and error
                    // is a connection timeout
                    guard Configuration.isAutoReconnectEnabled,
                          let bluetoothError = error as? CBError,
                          bluetoothError.code == .connectionTimeout else {
                        // Otherwise return out of function
                        return
                    }
                    // Reconnect
                    Task {
                        try await self.connect()
                    }
                default:
                    break
                }
            }
            .store(in: &self.cancellables)
        // Subscribe to events
        bluetoothManager
            .sink { [weak self] event in
                // Switch on event
                switch event {
                case .didUpdateState,
                        .didConnectPeripheral,
                        .didAuthenticatedPeripheral,
                        .peripheralDidUpdateValueForCharacteristic,
                        .didFailToConnectPeripheral,
                        .didDisconnectPeripheral:
                    // Send object will change
                    self?.objectWillChange.send()
                default:
                    break
                }
            }
            .store(in: &self.cancellables)
        // Subscribe to isScanning
        bluetoothManager
            .central
            .publisher(for: \.isScanning, options: [.new])
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // Send object will change
                self?.objectWillChange.send()
            }
            .store(in: &self.cancellables)
        // Return BluetoothManager
        return bluetoothManager
    }
    
}

// MARK: - DynamicMemberLookup

public extension VanMoof.Bike {
    
    /// Dynamic member lookup on the `VanMoof.Bike.Details`
    /// - Parameter keyPath: The KeyPath.
    subscript<Value>(
        dynamicMember keyPath: KeyPath<Details, Value>
    ) -> Value {
        self.details[keyPath: keyPath]
    }
    
}

// MARK: - Identifiable

extension VanMoof.Bike: Identifiable {
    
    /// The identifier of the bike.
    public var id: Details.ID {
        self.details.id
    }
    
}

// MARK: - Codable

extension VanMoof.Bike: Codable {
    
    /// Creates a new instance of `VanMoof.Bike`
    /// - Parameter decoder: The Decoder.
    public convenience init(
        from decoder: Decoder
    ) throws {
        self.init(
            details: try .init(from: decoder)
        )
    }
    
    /// Encode
    /// - Parameter encoder: The Encoder.
    public func encode(
        to encoder: Encoder
    ) throws {
        try self.details.encode(to: encoder)
    }
    
}

// MARK: - Equatable

extension VanMoof.Bike: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (
        lhs: VanMoof.Bike,
        rhs: VanMoof.Bike
    ) -> Bool {
        lhs.details == rhs.details
    }
    
}

// MARK: - Hashable

extension VanMoof.Bike: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(self.details)
    }
    
}

// MARK: - CustomStringConvertible

extension VanMoof.Bike: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        .init(
            describing: self.details
        )
    }
    
}
