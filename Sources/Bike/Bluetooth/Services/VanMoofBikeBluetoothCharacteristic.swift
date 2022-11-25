import Foundation

// MARK: - VanMoofBikeBluetoothCharacteristic

/// A VanMoof Bike Bluetooth Characteristic type
protocol VanMoofBikeBluetoothCharacteristic: Sendable {
    
    /// The identifier.
    static var id: String { get }
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic

/// A VanMoof Bike Bluetooth Readable Characteristic type
protocol VanMoofBikeBluetoothReadableCharacteristic: VanMoofBikeBluetoothCharacteristic {
    
    /// Bool value if data decryption is required before initializing.
    static var isDecryptionRequired: Bool { get }
    
    /// Creates a new instance from VanMoof Bike BluetoothData, if available
    /// - Parameter data: The VanMoof Bike BluetoothData
    init?(data: VanMoof.Bike.BluetoothData)
    
}

// MARK: - VanMoofBikeBluetoothReadableCharacteristic+Defaults

extension VanMoofBikeBluetoothReadableCharacteristic {
    
    /// Bool value if data decryption is required before initializing.
    static var isDecryptionRequired: Bool {
        true
    }
    
}

// MARK: - VanMoofBikeBluetoothWritableCharacteristic

/// A VanMoof Bike Bluetooth Writable Characteristic type
protocol VanMoofBikeBluetoothWritableCharacteristic: VanMoofBikeBluetoothCharacteristic {
    
    /// Bool value if data encryption is required.
    static var isEncryptionRequired: Bool { get }
    
    /// The writable bluetooth data.
    var writableData: VanMoof.Bike.BluetoothData { get }
    
}

// MARK: - VanMoofBikeBluetoothWritableCharacteristic+Defaults

extension VanMoofBikeBluetoothWritableCharacteristic {
    
    /// Bool value if data encryption is required.
    static var isEncryptionRequired: Bool {
        true
    }
    
}

// MARK: - VanMoofBikeBluetoothReadWritableCharacteristic

/// A VanMoof Bike Bluetooth Read- and Writable Characteristic type
typealias VanMoofBikeBluetoothReadWritableCharacteristic = VanMoofBikeBluetoothReadableCharacteristic & VanMoofBikeBluetoothWritableCharacteristic
