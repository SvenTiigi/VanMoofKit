import Combine
import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+BluetoothManager

extension VanMoof.Bike {
    
    /// A VanMoof Bike BluetoothManager.
    final class BluetoothManager: NSObject {
        
        // MARK: Properties
        
        /// The CBCentralManager.
        let central: CBCentralManager
        
        /// The VanMoof Bike BluetoothCrypto.
        let crypto: BluetoothCrypto
        
        /// The VanMoof Bike Details
        let details: Details
        
        /// The CBPeripheral.
        private(set) var peripheral: CBPeripheral?
        
        /// Bool value if peripheral  has been authenticated
        private(set) var isPeripheralAuthenticated = false
        
        /// The peripheral state subscription.
        private var peripheralStateSubscription: AnyCancellable?
        
        /// The Event CurrentValueSubject.
        private let eventSubject = CurrentValueSubject<Output?, Failure>(nil)
        
        // MARK: Initializer
        
        /// Creates a new instance of `VanMoof.Bike.BluetoothManager`
        /// - Parameters:
        ///   - details: The VanMoof Bike Details.
        ///   - central: The CBCentralManager.
        init(
            details: Details,
            central: CBCentralManager = .init(delegate: nil, queue: nil)
        ) {
            self.central = central
            self.crypto = .init(key: details.key)
            self.details = details
            super.init()
            // Setup
            self.setup()
        }
        
    }
    
}

// MARK: - Setup

private extension VanMoof.Bike.BluetoothManager {
    
    /// Setup BluetoothManager
    func setup() {
        // Set delegate
        self.central.delegate = self
        // Subscribe to bluetooth events to update the peripheral state
        self.peripheralStateSubscription = self.sink { [weak self] event in
            // Update state if needed for event
            self?.updateStateIfNeeded(for: event)
        }
    }
    
}

// MARK: - Publisher

extension VanMoof.Bike.BluetoothManager: Publisher {
    
    /// The kind of values published by this publisher.
    typealias Output = Event
    
    /// The kind of errors this publisher might publish.
    typealias Failure = Never
    
    /// Attaches the specified subscriber to this publisher.
    /// - Parameter subscriber: The subscriber to attach to this `Publisher`, after which it can receive values.
    func receive<S: Subscriber>(
        subscriber: S
    ) where S.Input == Output, S.Failure == Failure {
        self.eventSubject
            .compactMap { $0 }
            .receive(subscriber: subscriber)
    }
    
    /// Sends the Event to the subscriber.
    /// - Parameter event: The Event that should be send.
    func send(
        _ input: Output
    ) {
        self.eventSubject.send(input)
        // Log Event
        VanMoof.Log.log(
            message: .init(describing: input)
        )
    }
    
}

// MARK: - Update State if needed

private extension VanMoof.Bike.BluetoothManager {
    
    /// Update BluetoothManager state, if needed
    /// - Parameter event: The Event
    func updateStateIfNeeded(
        for event: Event
    ) {
        switch event {
        case .didDiscoverPeripheral(let peripheral, _, _):
            // Verify periphal matchesa with VanMoof Bike Details
            guard peripheral.matches(with: self.details) else {
                // Otherwise return out of function
                return
            }
            // Set delegate
            peripheral.delegate = self
            // Set peripheral
            self.peripheral = peripheral
            // Stop scanning
            self.central.stopScan()
            // Connect to peripheral
            self.central.connect(peripheral)
        case .didFailToConnectPeripheral, .didDisconnectPeripheral:
            // Clear peripheral
            self.peripheral = nil
            // Disable is authenticated
            self.isPeripheralAuthenticated = false
            // Send did update state event
            // as we are working with a `CurrentValueSubject`
            // we are overriding the current value with `.didUpdateState`
            self.send(.didUpdateState)
        case .peripheralDidWriteValueForCharacteristic(
            let peripheral,
            let characteristic,
            let error
        ) where characteristic.uuid == .init(
            string: VanMoof
                .Bike
                .BluetoothServices
                .Security
                .KeyIndexCharacteristic
                .id
        ):
            // Set is peripheral authenticated
            self.isPeripheralAuthenticated = error == nil
            // Send event on next run loop
            DispatchQueue.main.async { [weak self] in
                // Send didAuthenticated
                self?.send(
                    .didAuthenticatedPeripheral(
                        peripheral: peripheral,
                        characteristic: characteristic,
                        error: error
                    )
                )
            }
            // Check if an error is available
            if error != nil {
                // Perform Task
                Task {
                    // Disconnect as authentication failed
                    try await self.disconnect()
                }
            }
        default:
            break
        }
    }
    
}

// MARK: - CBPeripheral+matches(with:)

private extension CBPeripheral {
    
    /// Retrieve a Bool value if this peripheral matches with the VanMoof Bike Details
    /// - Parameter bikeDetails: The VanMoof Bike Details
    func matches(
        with bikeDetails: VanMoof.Bike.Details
    ) -> Bool {
        let peripheralMACAddress = self.name?.components(separatedBy: "-").last?.uppercased()
        let bikeMACAddress = bikeDetails.macAddress.replacingOccurrences(of: ":", with: "")
        return peripheralMACAddress == bikeMACAddress
    }
    
}
