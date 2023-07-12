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

// MARK: - VanMoof+Bike+BluetoothManager+Event+error

extension VanMoof.Bike.BluetoothManager.Event {
    
    /// The Error of the Event, if available.
    var error: Swift.Error? {
        switch self {
        case .didUpdateState,
                .didDiscoverPeripheral,
                .didConnectPeripheral,
                .peripheralDidUpdateName,
                .peripheralDidModifyServices,
                .peripheralIsReadyToSendWriteWithoutResponse:
            return nil
        case .didAuthenticatedPeripheral(_, _, let error),
                .didFailToConnectPeripheral(_, let error),
                .didDisconnectPeripheral(_, let error),
                .peripheralDidReadRSSI(_, _, let error),
                .peripheralDidDiscoverServices(_, let error),
                .peripheralDidDiscoverIncludedServices(_, _, let error),
                .peripheralDidDiscoverCharacteristics(_, _, let error),
                .peripheralDidUpdateValueForCharacteristic(_, _, let error),
                .peripheralDidWriteValueForCharacteristic(_, _, let error),
                .peripheralDidUpdateNotificationStateForCharacteristic(_, _, let error),
                .peripheralDidDiscoverDescriptorsForCharacteristic(_, _, let error),
                .peripheralDidUpdateValueForDescriptor(_, _, let error),
                .peripheralDidWriteValueForDescriptor(_, _, let error),
                .peripheralDidOpenChannel(_, _, let error):
            return error
        }
    }
    
}
