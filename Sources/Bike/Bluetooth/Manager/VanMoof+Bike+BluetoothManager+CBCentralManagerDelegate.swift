import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+BluetoothManager+CBCentralManagerDelegate

extension VanMoof.Bike.BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(
        _ central: CBCentralManager
    ) {
        self.send(
            .didUpdateState
        )
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        self.send(
            .didDiscoverPeripheral(
                peripheral: peripheral,
                advertisementData: advertisementData,
                rssi: RSSI
            )
        )
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        self.send(
            .didConnectPeripheral(
                peripheral: peripheral
            )
        )
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        self.send(
            .didFailToConnectPeripheral(
                peripheral: peripheral,
                error: error
            )
        )
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        self.send(
            .didDisconnectPeripheral(
                peripheral: peripheral,
                error: error
            )
        )
    }
    
}
