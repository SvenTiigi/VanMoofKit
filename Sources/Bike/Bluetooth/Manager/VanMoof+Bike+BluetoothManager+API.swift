import Combine
import CoreBluetooth
import Foundation

// MARK: - Connected Peripheral

private extension VanMoof.Bike.BluetoothManager {
    
    /// The connected CBPeripheral
    var connectedPeripheral: CBPeripheral {
        get throws {
            // Verify peripheral is available and connected
            guard let peripheral = self.peripheral,
                  peripheral.state == .connected else {
                // Otherwise throw error
                throw VanMoof
                    .Bike
                    .Error
                    .notConnected
            }
            // Return peripheral
            return peripheral
        }
    }
    
}

// MARK: - Connect

extension VanMoof.Bike.BluetoothManager {
    
    /// Establish a connection to the VanMoof Bike.
    /// - Parameter timeoutInterval: The timeout interval. Default value `VanMoof.Bike.timeoutInterval`
    func connect(
        timeoutInterval: TimeInterval = VanMoof.Bike.timeoutInterval
    ) async throws {
        // Verify connection state is not connected
        guard self.peripheral?.state != .connected else {
            // Otherwise return out of function
            return
        }
        // Perform with timeout
        try await self.withTimeout(seconds: timeoutInterval) {
            // For each bluetooth event
            for try await event in self.values {
                // Check central state
                try self.central.checkState()
                // Check if a peripheral is available
                if self.peripheral != nil {
                    // Switch on event
                    switch event {
                    case .didConnectPeripheral:
                        // Discover all services
                        try await self.discoverAllServices()
                        // Discover all characteristics
                        try await self.discoverAllCharacteristics()
                        // Authenticate connection
                        try await self.authenticate()
                        // Return out of function
                        return
                    case .didFailToConnectPeripheral(_, let error),
                            .didDisconnectPeripheral(_, let error):
                        // Throw error
                        throw VanMoof.Bike.Error(
                            underlyingError: error
                        )
                    default:
                        // Continue with next event
                        continue
                    }
                } else if !self.central.isScanning {
                    // Scan for peripherals
                    self.central.scanForPeripherals(
                        withServices: VanMoof
                            .Bike
                            .BluetoothServices
                            .all
                            .map { $0.id }
                            .map(CBUUID.init)
                    )
                }
            }
        }
    }
    
    /// Discover all Services.
    private func discoverAllServices() async throws {
        // Discover all services
        try self.connectedPeripheral.discoverServices(
            VanMoof
                .Bike
                .BluetoothServices
                .all
                .map { $0.id }
                .map(CBUUID.init)
        )
        // For each bluetooth event where the peripheral matches
        for try await event in self.values {
            // Check central state
            try self.central.checkState()
            // Switch event
            switch event {
            case .peripheralDidDiscoverServices(_, let error):
                // Check if an error is available
                if let error = error {
                    // Throw error
                    throw VanMoof.Bike.Error(
                        underlyingError: error
                    )
                } else {
                    // Return out of function
                    // as periphal successfully disovered services
                    return
                }
            case .didDisconnectPeripheral(_, let error):
                // Throw error
                throw VanMoof.Bike.Error(
                    underlyingError: error
                )
            default:
                // Otherwise continue with next event
                continue
            }
        }
    }
    
    /// Discover all characteristics.
    private func discoverAllCharacteristics() async throws {
        // Initialize connected peripheral
        let peripheral = try self.connectedPeripheral
        // Verify services are available
        guard let services = peripheral.services.flatMap(Set.init) else {
            // Otherwise return out of function
            return
        }
        // For each service
        for service in services {
            // Discover characteristics
            peripheral.discoverCharacteristics(
                VanMoof
                    .Bike
                    .BluetoothServices
                    .all
                    .first { service.uuid == .init(string: $0.id) }?
                    .characteristics
                    .map { $0.id }
                    .map(CBUUID.init),
                for: service
            )
        }
        // Initialize mutable discovered services
        var discoveredServices = services
        // For each bluetooth event
        for try await event in self.values {
            // Check central state
            try self.central.checkState()
            // Switch on event
            switch event {
            case .peripheralDidDiscoverCharacteristics(_, let service, _):
                // Verify service could be removed
                guard discoveredServices.remove(service) != nil else {
                    // Otherwise continue with next event
                    continue
                }
                // Enable notifications for each characteristic
                service
                    .characteristics?
                    .forEach { characteristic in
                        // Verify characteristic properties contains notify
                        guard characteristic.properties.contains(.notify) else {
                            // Otherwise return out of function
                            return
                        }
                        // Enable notify
                        peripheral.setNotifyValue(
                            true,
                            for: characteristic
                        )
                    }
                // Check if all characteristics have been discovered
                if discoveredServices.isEmpty {
                    // Return out of function
                    return
                }
            case .didDisconnectPeripheral(_, let error):
                // Throw error
                throw VanMoof.Bike.Error(
                    underlyingError: error
                )
            default:
                // Otherwise continue with next event
                continue
            }
        }
    }
    
    /// Authenticate connection.
    private func authenticate() async throws {
        try await self.write(
            characteristic: VanMoof
                .Bike
                .BluetoothServices
                .Security
                .KeyIndexCharacteristic(
                    challenge: await self.read(
                        characteristic: VanMoof
                            .Bike
                            .BluetoothServices
                            .Security
                            .ChallengeCharacteristic.self
                    ),
                    crypto: self.crypto
                )
        )
    }
    
}

// MARK: - Disconnect

extension VanMoof.Bike.BluetoothManager {
    
    /// Disconnect from VanMoof Bike.
    /// - Parameter timeoutInterval: The timeout interval. Default value `VanMoof.Bike.timeoutInterval
    func disconnect(
        timeoutInterval: TimeInterval = VanMoof.Bike.timeoutInterval
    ) async throws {
        // Check central state
        try self.central.checkState()
        // Cancel peripheral connection
        try self.central.cancelPeripheralConnection(self.connectedPeripheral)
        // Perform with timeout
        try await self.withTimeout(seconds: timeoutInterval) {
            // For each bluetooth event
            for try await event in self.values {
                // Switch on event
                switch event {
                case .didDisconnectPeripheral:
                    // Return out of function
                    return
                default:
                    // Continue with next event
                    continue
                }
            }
        }
    }
    
}

// MARK: - Publisher

extension VanMoof.Bike.BluetoothManager {
    
    /// A Publisher that emits a VanMoofBikeBluetoothCharacteristic whenever a new value is available
    /// - Parameter characteristic: The VanMoofBikeBluetoothCharacteristic type.
    func publisher<Characteristic: VanMoofBikeBluetoothReadableCharacteristic>(
        for characteristic: Characteristic.Type
    ) -> AnyPublisher<Characteristic, Never> {
        self.compactMap { event in
            switch event {
            case .peripheralDidUpdateValueForCharacteristic(
                _,
                let coreBluetoothCharacteristic,
                _
            ) where coreBluetoothCharacteristic.uuid == .init(string: characteristic.id):
                return try? .init(
                    characteristic: coreBluetoothCharacteristic,
                    crypto: self.crypto
                )
            default:
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
}

// MARK: - Read RSSI

extension VanMoof.Bike.BluetoothManager {
    
    /// Retrieves the current RSSI value for the connected peripheral.
    /// - Parameter timeoutInterval: The timeout interval. Default value `VanMoof.Bike.timeoutInterval
    func readRSSI(
        timeoutInterval: TimeInterval = VanMoof.Bike.timeoutInterval
    ) async throws -> NSNumber {
        // Read RSSI
        try self.connectedPeripheral.readRSSI()
        // Perform with timeout
        return try await self.withTimeout(seconds: timeoutInterval) {
            // For each bluetooth event
            for try await event in self.values {
                // Check central state
                try self.central.checkState()
                // Switch on event
                switch event {
                case .peripheralDidReadRSSI(_, let rssi, let error):
                    // Check if an error is available
                    if let error = error {
                        // Throw error
                        throw VanMoof.Bike.Error(
                            underlyingError: error
                        )
                    } else {
                        // Return the current RSSI
                        return rssi
                    }
                case .didDisconnectPeripheral(_, let error):
                    // Throw error
                    throw VanMoof.Bike.Error(
                        underlyingError: error
                    )
                default:
                    continue
                }
            }
            // Otherwise throw error
            throw VanMoof.Bike.Error(
                errorDescription: "RSSI is unavailable"
            )
        }
    }
    
}

// MARK: - Read Characteristic

extension VanMoof.Bike.BluetoothManager {
    
    /// Read VanMoof Bike Bluetooth Characteristic.
    /// - Parameters:
    ///   - characteristic: The VanMoof Bike Bluetooth Characteristic type to read.
    ///   - timeoutInterval: The timeout interval. Default value `VanMoof.Bike.timeoutInterval
    func read<Characteristic: VanMoofBikeBluetoothReadableCharacteristic>(
        characteristic: Characteristic.Type,
        timeoutInterval: TimeInterval = VanMoof.Bike.timeoutInterval
    ) async throws -> Characteristic {
        // Check central state
        try self.central.checkState()
        // Retrieve CoreBluetooth characterstic
        let coreBluetoothCharacteristic = try self.connectedPeripheral.characteristic(characteristic)
        // Read value for CoreBluetooth characterstic
        try self.connectedPeripheral.readValue(for: coreBluetoothCharacteristic)
        // Perform with timeout
        return try await self.withTimeout(seconds: timeoutInterval) {
            // For each bluetooth event
            for try await event in self.values {
                // Check central state
                try self.central.checkState()
                // Switch on event
                switch event {
                case .peripheralDidUpdateValueForCharacteristic(
                    _,
                    let updatedCoreBluetoothCharacteristic,
                    let error
                ) where updatedCoreBluetoothCharacteristic == coreBluetoothCharacteristic:
                    // Check if an error is available
                    // which is not instance of `CBATTError.unlikelyError`
                    if let error = error, (error as? CBATTError)?.code != .unlikelyError {
                        // Throw error
                        throw VanMoof.Bike.Error(
                            underlyingError: error
                        )
                    }
                    // Return characteristic
                    return try .init(
                        characteristic: updatedCoreBluetoothCharacteristic,
                        crypto: self.crypto
                    )
                case .didDisconnectPeripheral(_, let error):
                    // Throw error
                    throw VanMoof.Bike.Error(
                        underlyingError: error
                    )
                default:
                    // Otherwise continue with next event
                    continue
                }
            }
            // Otherwise throw error
            throw VanMoof.Bike.Error(
                errorDescription: "\(Characteristic.self) is unavailable"
            )
        }
    }
    
}

// MARK: - Write Characteristic

extension VanMoof.Bike.BluetoothManager {
    
    /// Write VanMoof Bike Bluetooth Characteristic.
    /// - Parameters:
    ///   - characteristic: The VanMoof Bike Bluetooth Characteristic to write.
    ///   - timeoutInterval: The timeout interval. Default value `VanMoof.Bike.timeoutInterval
    func write<Characteristic: VanMoofBikeBluetoothWritableCharacteristic>(
        characteristic: Characteristic,
        timeoutInterval: TimeInterval = VanMoof.Bike.timeoutInterval
    ) async throws {
        // Check central state
        try self.central.checkState()
        // Retrieve CoreBluetooth Characteristic
        let coreBluetoothCharacteristic = try self.connectedPeripheral.characteristic(Characteristic.self)
        // Initialize CoreBluetooth Characteristic WriteType
        let writeType: CBCharacteristicWriteType = coreBluetoothCharacteristic.properties.contains(.write)
            ? .withResponse
            : .withoutResponse
        // Write value for characteristic
        try self.connectedPeripheral.writeValue(
            await {
                // Verify encryption is required
                guard Characteristic.isEncryptionRequired else {
                    // Otherwise return writable value without encryption
                    return characteristic.writableData.rawValue
                }
                // Read ChallengeCharacteristic
                let challengeCharacteristic = try await self.read(
                    characteristic: VanMoof
                        .Bike
                        .BluetoothServices
                        .Security
                        .ChallengeCharacteristic.self
                )
                // Return encrypted data
                return try self.crypto
                    .encrypt(
                        data: characteristic
                            .writableData
                            .addingNonce(from: challengeCharacteristic)
                            .rawValue
                    )
            }(),
            for: coreBluetoothCharacteristic,
            type: writeType
        )
        // Verify write type is with response
        guard writeType == .withResponse else {
            // Otherwise return out of function
            return
        }
        // Perform with timeout
        try await self.withTimeout(seconds: timeoutInterval) {
            // For each bluetooth event
            for try await event in self.values {
                // Check central state
                try self.central.checkState()
                // Switch on event
                switch event {
                case .peripheralDidWriteValueForCharacteristic(
                    _,
                    let updatedCoreBluetoothCharacterstic,
                    let error
                ) where updatedCoreBluetoothCharacterstic.uuid == coreBluetoothCharacteristic.uuid:
                    // Check if an error is available
                    if let error = error {
                        // Throw error
                        throw VanMoof.Bike.Error(
                            underlyingError: error
                        )
                    } else {
                        // Delay execution after one second
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 1
                        ) { [weak self] in
                            // Read value
                            try? self?.connectedPeripheral
                                .readValue(
                                    for: updatedCoreBluetoothCharacterstic
                                )
                        }
                        // Return out of function
                        // as write was successful
                        return
                    }
                case .didDisconnectPeripheral(_, let error):
                    // Throw error
                    throw VanMoof.Bike.Error(
                        underlyingError: error
                    )
                default:
                    // Otherwise continue with next event
                    continue
                }
            }
        }
    }
    
}

// MARK: - CBPeripheral+characteristic
 
private extension CBPeripheral {
    
    /// Retrieve a CBCharacteristic for a given VanMoofBikeBluetoothCharacteristic type,
    /// or throws a `VanMoof.Bike.Error` if not available
    /// - Parameter characteristic: The VanMoofBikeBluetoothCharacteristic type.
    func characteristic(
        _ characteristic: VanMoofBikeBluetoothCharacteristic.Type
    ) throws -> CBCharacteristic {
        // Verify characteristic is available
        guard let characteristic = self.services?
            .compactMap(\.characteristics)
            .flatMap({ $0 })
            .first(where: { $0.uuid == .init(string: characteristic.id) }) else {
            // Otherwise throw error
            throw VanMoof.Bike.Error(
                errorDescription: "\(characteristic.self) not found"
            )
        }
        // Return characteristic
        return characteristic
    }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic+init(characteristic:)

private extension VanMoofBikeBluetoothReadableCharacteristic {
    
    /// Creates a new instance of `VanMoofBikeBluetoothReadableCharacteristic`
    /// - Parameters:
    ///   - characteristic: The CBCharacteristic
    ///   - crypto: The BluetoothCrypto
    init(
        characteristic: CBCharacteristic,
        crypto: VanMoof.Bike.BluetoothCrypto
    ) throws {
        // Verify characteristic value is available
        guard var characteristicValue = characteristic.value else {
            // Otherwise throw an error
            throw VanMoof.Bike.Error(
                errorDescription: "\(Self.self) value unavailable"
            )
        }
        // Check if decryption is required
        if Self.isDecryptionRequired {
            // Decrypt characteristic value
            characteristicValue = try crypto.decrypt(data: characteristicValue)
        }
        // Verify characteristic can be initialized
        guard let characteristic = Self(data: .init(characteristicValue)) else {
            // Otherwise throw an error
            throw VanMoof.Bike.Error(
                errorDescription: "\(Self.self) invalid value"
            )
        }
        // Initialize
        self = characteristic
    }
    
}

// MARK: - With Timeout

private extension VanMoof.Bike.BluetoothManager {
    
    /// Execute an operation in the current task subject to a timeout.
    /// - Copyright: https://forums.swift.org/t/running-an-async-task-with-a-timeout/49733/13
    /// - Parameters:
    ///   - seconds: The duration in seconds `operation` is allowed to run before timing out.
    ///   - operation: The async operation to perform.
    /// - Returns: Returns the result of `operation` if it completed in time.
    /// - Throws: Throws `VanMoof.Bike.Error` if the timeout expires before `operation` completes.
    ///   If `operation` throws an error before the timeout expires, that error is propagated to the caller.
    func withTimeout<R>(
        seconds: TimeInterval,
        operation: @escaping @Sendable () async throws -> R
    ) async throws -> R {
        try await withThrowingTaskGroup(of: R.self) { group in
            // Initialize deadline
            let deadline = Date(timeIntervalSinceNow: seconds)
            // Add operation Task
            group.addTask {
                // Execute operation
                return try await operation()
            }
            // Add timeout Task
            group.addTask {
                // Initialize interval
                let interval = deadline.timeIntervalSinceNow
                // Check if interval is greater zero
                if interval > 0 {
                    // Sleep
                    try await Task.sleep(
                        nanoseconds: .init(interval * 1_000_000_000)
                    )
                }
                // Check cancellation
                try Task.checkCancellation()
                // Throw error
                throw VanMoof.Bike.Error.timedOut
            }
            // Await first result
            let result = try await group.next()
            // Cancel all other tasks
            group.cancelAll()
            // Verify result is available
            guard let result = result else {
                // Otherwise throw error
                throw VanMoof.Bike.Error.timedOut
            }
            // Return result
            return result
        }
    }
    
}

// MARK: - CBManagerState+isError

private extension CBCentralManager {
    
    /// A set of `CBManagerState` elements representing `bad` states.
    static let badStates: Set<CBManagerState> = [
        .unsupported,
        .unauthorized,
        .poweredOff
    ]
    
    /// Throws a VanMoof Bike Error if a bad `state` is present.
    func checkState() throws {
        // Verify state is bad
        guard Self.badStates.contains(self.state) else {
            // Otherwise return out of function
            return
        }
        // Throw a VanMoof Bike Error
        throw VanMoof.Bike.Error(
            errorDescription: "Bad Bluetooth State \(self)"
        )
    }
    
}
