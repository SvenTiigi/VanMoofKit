import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+BluetoothManager+CBPeripheralDelegate

extension VanMoof.Bike.BluetoothManager: CBPeripheralDelegate {
    
    func peripheralDidUpdateName(
        _ peripheral: CBPeripheral
    ) {
        self.send(
            .peripheralDidUpdateName(peripheral: peripheral)
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didModifyServices invalidatedServices: [CBService]
    ) {
        self.send(
            .peripheralDidModifyServices(
                peripheral: peripheral,
                invalidatedServices: invalidatedServices
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didReadRSSI RSSI: NSNumber,
        error: Error?
    ) {
        self.send(
            .peripheralDidReadRSSI(
                peripheral: peripheral,
                rssi: RSSI,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        self.send(
            .peripheralDidDiscoverServices(
                peripheral: peripheral,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverIncludedServicesFor service: CBService,
        error: Error?
    ) {
        self.send(
            .peripheralDidDiscoverIncludedServices(
                peripheral: peripheral,
                service: service,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        self.send(
            .peripheralDidDiscoverCharacteristics(
                peripheral: peripheral,
                service: service,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        self.send(
            .peripheralDidUpdateValueForCharacteristic(
                peripheral: peripheral,
                characteristic: characteristic,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        self.send(
            .peripheralDidWriteValueForCharacteristic(
                peripheral: peripheral,
                characteristic: characteristic,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateNotificationStateFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        self.send(
            .peripheralDidUpdateNotificationStateForCharacteristic(
                peripheral: peripheral,
                characteristic: characteristic,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverDescriptorsFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        self.send(
            .peripheralDidDiscoverDescriptorsForCharacteristic(
                peripheral: peripheral,
                characteristic: characteristic,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor descriptor: CBDescriptor,
        error: Error?
    ) {
        self.send(
            .peripheralDidUpdateValueForDescriptor(
                peripheral: peripheral,
                descriptor: descriptor,
                error: error
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor descriptor: CBDescriptor,
        error: Error?
    ) {
        self.send(
            .peripheralDidWriteValueForDescriptor(
                peripheral: peripheral,
                descriptor: descriptor,
                error: error
            )
        )
    }
    
    func peripheralIsReady(
        toSendWriteWithoutResponse peripheral: CBPeripheral
    ) {
        self.send(
            .peripheralIsReadyToSendWriteWithoutResponse(
                peripheral: peripheral
            )
        )
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didOpen channel: CBL2CAPChannel?,
        error: Error?
    ) {
        self.send(
            .peripheralDidOpenChannel(
                peripheral: peripheral,
                channel: channel,
                error: error
            )
        )
    }
    
}
