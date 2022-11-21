import CoreBluetooth
import Foundation

// MARK: - VanMoof+Bike+BluetoothManager+Event

extension VanMoof.Bike.BluetoothManager {
    
    /// A VanMoof Bike BluetoothManager Event
    enum Event {
        case didUpdateState
        case didDiscoverPeripheral(
            peripheral: CBPeripheral,
            advertisementData: [String: Any],
            rssi: NSNumber
        )
        case didConnectPeripheral(
            peripheral: CBPeripheral
        )
        case didAuthenticatedPeripheral(
            peripheral: CBPeripheral,
            characteristic: CBCharacteristic,
            error: Error?
        )
        case didFailToConnectPeripheral(
            peripheral: CBPeripheral,
            error: Error?
        )
        case didDisconnectPeripheral(
            peripheral: CBPeripheral,
            error: Error?
        )
        case peripheralDidUpdateName(
            peripheral: CBPeripheral
        )
        case peripheralDidModifyServices(
            peripheral: CBPeripheral,
            invalidatedServices: [CBService]
        )
        case peripheralDidReadRSSI(
            peripheral: CBPeripheral,
            rssi: NSNumber,
            error: Error?
        )
        case peripheralDidDiscoverServices(
            peripheral: CBPeripheral,
            error: Error?
        )
        case peripheralDidDiscoverIncludedServices(
            peripheral: CBPeripheral,
            service: CBService,
            error: Error?
        )
        case peripheralDidDiscoverCharacteristics(
            peripheral: CBPeripheral,
            service: CBService,
            error: Error?
        )
        case peripheralDidUpdateValueForCharacteristic(
            peripheral: CBPeripheral,
            characteristic: CBCharacteristic,
            error: Error?
        )
        case peripheralDidWriteValueForCharacteristic(
            peripheral: CBPeripheral,
            characteristic: CBCharacteristic,
            error: Error?
        )
        case peripheralDidUpdateNotificationStateForCharacteristic(
            peripheral: CBPeripheral,
            characteristic: CBCharacteristic,
            error: Error?
        )
        case peripheralDidDiscoverDescriptorsForCharacteristic(
            peripheral: CBPeripheral,
            characteristic: CBCharacteristic,
            error: Error?
        )
        case peripheralDidUpdateValueForDescriptor(
            peripheral: CBPeripheral,
            descriptor: CBDescriptor,
            error: Error?
        )
        case peripheralDidWriteValueForDescriptor(
            peripheral: CBPeripheral,
            descriptor: CBDescriptor,
            error: Error?
        )
        case peripheralIsReadyToSendWriteWithoutResponse(
            peripheral: CBPeripheral
        )
        case peripheralDidOpenChannel(
            peripheral: CBPeripheral,
            channel: CBL2CAPChannel?,
            error: Error?
        )
    }
    
}
