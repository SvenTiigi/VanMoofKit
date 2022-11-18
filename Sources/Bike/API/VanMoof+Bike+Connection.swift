import Combine
import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+connectionState

public extension VanMoof.Bike {
    
    /// The connection state.
    var connectionState: CBPeripheralState? {
        self.peripheral?.rawValue.state
    }
    
}

// MARK: - VanMoof+Bike+connect

public extension VanMoof.Bike {
    
    /// Connect to the VanMoof Bike.
    func connect() async throws {
        guard self.connectionState != .connected else {
            return
        }
        for try await event in self.bluetoothPublisher.values {
            if let peripheral = self.peripheral {
                if self.bluetoothPublisher.isScanning {
                    self.bluetoothPublisher.stopScan()
                }
                guard event.peripheral == peripheral.rawValue else {
                    continue
                }
                switch event {
                case .didConnectPeripheral:
                    // Discover all services
                    try await peripheral.discoverAllServices()
                    // Discover all characteristics
                    peripheral.discoverAllCharacteristics()
                    // Verify Challenge Characterstic is available
                    guard let challengeCharacteristic = try await peripheral
                        .characteristic(VanMoofBikeBluetoothServices.Security.ChallengeCharacteristic.self) else {
                        // Otherwise throw an error
                        throw Error(errorDescription: "Challenge Characteristic not found")
                    }
                    // Read nonce from Challenge Characterstic
                    guard let nonce = try await peripheral.readValue(for: challengeCharacteristic) else {
                        // Otherwise throw an error
                        throw Error(errorDescription: "Challenge Characteristic Value not available")
                    }
                    try peripheral.writeValue(nonce, for: challengeCharacteristic)
                case .didFailToConnectPeripheral(_, let error),
                        .didDisconnectPeripheral(_, let error):
                    throw Error(underlyingError: error)
                default:
                    continue
                }
            } else if !self.bluetoothPublisher.isScanning {
                if self.bluetoothPublisher.state == .unsupported
                    || self.bluetoothPublisher.state == .unauthorized {
                    throw Error(
                        errorDescription: "Bad CBCentralManager State \(self.bluetoothPublisher.state)"
                    )
                }
                self.bluetoothPublisher.scanForPeripherals(
                    withServices: VanMoofBikeBluetoothServices
                        .all
                        .map { $0.id }
                        .map(CBUUID.init)
                )
            }
        }
    }
    
}

// MARK: - VanMoof+Bike+disconnect

public extension VanMoof.Bike {
    
    /// Disconnect from VanMoof Bike.
    func disconnect() async {
        guard self.connectionState == .connected else {
            return
        }
        defer {
            self.peripheral.flatMap { self.bluetoothPublisher.cancelPeripheralConnection($0.rawValue) }
        }
        for try await event in self.bluetoothPublisher.values {
            switch event {
            case .didDisconnectPeripheral(let peripheral, _) where peripheral == self.peripheral?.rawValue:
                return
            default:
                break
            }
        }
    }
    
}
