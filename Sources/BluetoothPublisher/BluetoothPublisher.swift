import Combine
import CoreBluetooth
import Foundation

// MARK: - BluetoothPublisher

/// A Publisher that emits bluetooth events
final class BluetoothPublisher: CBCentralManager {

    // MARK: Properties
    
    /// The CBPeripherals
    private(set) var peripherals = Set<CBPeripheral>()
    
    /// The past Events
    private(set) var pastEvents = [Event]()
    
    /// The Output Subject
    private lazy var subject = CurrentValueSubject<Output?, Failure>(nil)
    
    // MARK: Initializer
    
    /// Creates a new instance of `BluetoothPublisher`
    override init(
        delegate: CBCentralManagerDelegate?,
        queue: DispatchQueue?,
        options: [String : Any]? = nil
    ) {
        super.init(
            delegate: nil,
            queue: nil,
            options: nil
        )
        self.delegate = self
    }
    
    /// Deinit
    deinit {
        self.delegate = nil
        self.peripherals.forEach(self.cancelPeripheralConnection)
    }
    
}

// MARK: - Publisher

extension BluetoothPublisher: Publisher {
    
    /// The kind of values published by this publisher.
    typealias Output = Event
    
    /// The kind of errors this publisher might publish.
    typealias Failure = Never
    
    /// Attaches the specified subscriber to this publisher.
    /// - Parameter subscriber: The subscriber to attach to this `Publisher`, after which it can receive values.
    func receive<S: Subscriber>(
        subscriber: S
    ) where S.Input == Output, S.Failure == Failure {
        self.subject
            .compactMap { $0 }
            .receive(subscriber: subscriber)
    }
    
}

// MARK: - Advertisement Data

extension BluetoothPublisher {
    
    /// Retrieve advertisement data for a given peripheral, if available
    /// - Parameter peripheral: The CBPeripheral to retrieve advertisement data for
    /// - Returns: The advertisement data, if available
    func advertisementData(
        for peripheral: CBPeripheral
    ) -> [String: Any]? {
        for event in self.pastEvents.reversed() {
            switch event {
            case .didDiscoverPeripheral(
                let discoveredPeripheral,
                let advertisementData,
                _
            ) where discoveredPeripheral == peripheral:
                return advertisementData
            default:
                continue
            }
        }
        return nil
    }
    
}

// MARK: - Send

private extension BluetoothPublisher {
    
    /// Sends the Event to the subscriber.
    /// - Parameter event: The Event that should be send.
    func send(
        _ event: Event
    ) {
        #if DEBUG
        Swift.print(Date(), "Bluetooth Event", event)
        #endif
        self.pastEvents.append(event)
        self.subject.send(event)
    }
    
}

// MARK: - Event

extension BluetoothPublisher {
    
    /// A BluetoothPublisher Event
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

// MARK: - Event+peripheral

extension BluetoothPublisher.Event {
    
    /// The CBPeripheral, if available
    var peripheral: CBPeripheral? {
        switch self {
        case .didUpdateState:
            return nil
        case .didDiscoverPeripheral(let peripheral, _, _),
                .didConnectPeripheral(let peripheral),
                .didFailToConnectPeripheral(let peripheral, _),
                .didDisconnectPeripheral(let peripheral, _),
                .peripheralDidUpdateName(let peripheral),
                .peripheralDidModifyServices(let peripheral, _),
                .peripheralDidReadRSSI(let peripheral, _, _),
                .peripheralDidDiscoverServices(let peripheral, _),
                .peripheralDidDiscoverIncludedServices(let peripheral, _, _),
                .peripheralDidDiscoverCharacteristics(let peripheral, _, _),
                .peripheralDidUpdateValueForCharacteristic(let peripheral, _, _),
                .peripheralDidWriteValueForCharacteristic(let peripheral, _, _),
                .peripheralDidUpdateNotificationStateForCharacteristic(let peripheral, _, _),
                .peripheralDidDiscoverDescriptorsForCharacteristic(let peripheral, _, _),
                .peripheralDidUpdateValueForDescriptor(let peripheral, _, _),
                .peripheralDidWriteValueForDescriptor(let peripheral, _, _),
                .peripheralIsReadyToSendWriteWithoutResponse(let peripheral),
                .peripheralDidOpenChannel(let peripheral, _, _):
            return peripheral
        }
    }
    
}

// MARK: - CBCentralManagerDelegate

extension BluetoothPublisher: CBCentralManagerDelegate {
    
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
        self.peripherals.insert(peripheral)
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
        peripheral.delegate = self
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
        self.peripherals.remove(peripheral)
        self.send(
            .didDisconnectPeripheral(
                peripheral: peripheral,
                error: error
            )
        )
    }
    
}

// MARK: - CBPeripheralDelegate

extension BluetoothPublisher: CBPeripheralDelegate {
    
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
