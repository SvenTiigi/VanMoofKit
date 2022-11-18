import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+peripheral

extension VanMoof.Bike {
    
    /// The Peripheral, if available.
    var peripheral: Peripheral? {
        .init(bike: self)
    }
    
}

// MARK: - VanMoof+Bike+Peripheral

extension VanMoof.Bike {
    
    /// The VanMoof Bike Bluetooth Peripheral
    struct Peripheral {
        
        // MARK: Properties
        
        /// The CBPeripheral.
        let rawValue: CBPeripheral
        
        /// The BluetoothPublisher.
        let bluetoothPublisher: BluetoothPublisher
        
        /// The Crypto.
        let crypto: Crypto
        
        // MARK: Initializer
        
        /// Creates a  new instance of `VanMoof.Bike.Peripheral`, if available.
        /// - Parameter bike: The VanMoof Bike.
        init?(
            bike: VanMoof.Bike
        ) {
            guard let peripheral = bike
                .bluetoothPublisher
                .peripherals
                .first(where: { peripheral in
                    peripheral
                        .name?
                        .split(separator: "-")
                        .last?
                        .uppercased()
                    ==
                    bike.details
                        .macAddress
                        .replacingOccurrences(of: ":", with: "")
                        .uppercased()
                }) else {
                return nil
            }
            self.rawValue = peripheral
            self.bluetoothPublisher = bike.bluetoothPublisher
            self.crypto = bike.crypto
        }
        
    }
    
}

// MARK: - Discover all Services

extension VanMoof.Bike.Peripheral {
    
    /// Discover all Services.
    func discoverAllServices() async throws {
        // Discover services
        self.rawValue.discoverServices(
            VanMoofBikeBluetoothServices
                .all
                .map { $0.id }
                .map(CBUUID.init)
        )
        // For each bluetooth event
        for try await event in self.bluetoothPublisher.values {
            // Switch event
            switch event {
            case .peripheralDidDiscoverServices(
                let periperhal,
                let error
            ) where periperhal == self.rawValue:
                // Check if an error is available
                if let error = error {
                    // Throw error
                    throw VanMoof.Bike.Error(underlyingError: error)
                } else {
                    // Return out of function
                    return
                }
            default:
                continue
            }
        }
    }
    
}

// MARK: - Discover all Characteristics

extension VanMoof.Bike.Peripheral {
    
    /// Discover all characteristics.
    func discoverAllCharacteristics() {
        // Verify services are available
        guard let services = self.rawValue.services else {
            // Otherwise return out of function
            return
        }
        // For each service
        for service in services {
            // Discover characteristics
            self.rawValue.discoverCharacteristics(
                VanMoofBikeBluetoothServices
                    .all
                    .first { service.uuid == CBUUID(string: $0.id) }?
                    .characteristics
                    .map { $0.id }
                    .map(CBUUID.init),
                for: service
            )
        }
    }
    
}

// MARK: - Characteristic

extension VanMoof.Bike.Peripheral {
    
    /// Retrieve CBCharacteristic for a given VanMoofBikeBluetoothCharacteristic type, if available.
    /// - Parameter characteristic: The VanMoofBikeBluetoothCharacteristic type.
    func characteristic(
        _ characteristic: VanMoofBikeBluetoothCharacteristic.Type
    ) async throws -> CBCharacteristic? {
        // Check if the characteristic is already available
        if let characteristic = self.rawValue
            .services?
            .compactMap(\.characteristics)
            .flatMap({ $0 })
            .first(where: { $0.uuid == CBUUID(string: characteristic.id) }) {
            // Return characteristic
            return characteristic
        }
        for try await event in self.bluetoothPublisher.values {
            switch event {
            case .peripheralDidDiscoverCharacteristics(
                let peripheral,
                let service,
                let error
            ) where peripheral == self.rawValue:
                guard service.uuid.uuidString == VanMoofBikeBluetoothServices
                    .all
                    .first(where: { service in
                        service.characteristics.contains(where: { $0.id == characteristic.id })
                    })?
                    .id else {
                    continue
                }
                if let error = error {
                    throw VanMoof.Bike.Error(underlyingError: error)
                } else {
                    return service
                        .characteristics?
                        .first(where: { $0.uuid == CBUUID(string: characteristic.id) })
                }
            default:
                continue
            }
        }
        return nil
    }
    
}

extension VanMoof.Bike.Peripheral {
    
    func writeValue(
        for characteristic: VanMoofBikeBluetoothCharacteristic,
        type: CBCharacteristicWriteType = .withoutResponse
    ) throws {
        let value = characteristic.value
        guard let characteristic = self.rawValue
            .services?
            .compactMap(\.characteristics)
            .flatMap({ $0 })
            .first(where: { $0.uuid == CBUUID(string: characteristic.id) }) else {
            throw VanMoof.Bike.Error(errorDescription: "Characteristic not found \(characteristic)")
        }
        try self.writeValue(value, for: characteristic, type: type)
    }
    
    func writeValue(
        _ data: Data,
        for characteristic: CBCharacteristic,
        type: CBCharacteristicWriteType = .withoutResponse
    ) throws {
        self.rawValue.writeValue(
            try self.crypto.encrypt(data: data),
            for: characteristic,
            type: type
        )
    }
    
}

extension VanMoof.Bike.Peripheral {
    
    func readValue(
        _ characteristic: VanMoofBikeBluetoothCharacteristic.Type
    ) async throws -> Data? {
        guard let characteristic = try await self.characteristic(characteristic) else {
            return nil
        }
        return try await self.readValue(for: characteristic)
    }
    
    func readValue(
        for characteristic: CBCharacteristic
    ) async throws -> Data? {
        self.rawValue.readValue(for: characteristic)
        for try await event in self.bluetoothPublisher.values {
            switch event {
            case .peripheralDidUpdateValueForCharacteristic(
                let peripheral,
                let updatedCharacteristic,
                let error
            ) where peripheral == self.rawValue && updatedCharacteristic == characteristic:
                if let error = error {
                    throw VanMoof.Bike.Error(underlyingError: error)
                }
                return try updatedCharacteristic.value.flatMap(self.crypto.decrypt)
            default:
                break
            }
        }
        return nil
    }
    
}
