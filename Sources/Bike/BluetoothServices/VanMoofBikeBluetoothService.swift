import Foundation

// MARK: - VanMoofBikeBluetoothService

/// A VanMoof Bike Bluetooth Service type
protocol VanMoofBikeBluetoothService {
    
    /// The identifier.
    static var id: String { get }
    
    /// The characteristics.
    static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] { get }
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic

/// A VanMoof Bike Bluetooth Characteristic type
protocol VanMoofBikeBluetoothCharacteristic {
    
    /// The identifier.
    static var id: String { get }
    
    /// The value.
    var value: Data { get }
    
    /// Creates a new instance, if available.
    /// - Parameter value: The value.
    init?(value: Data)
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic+Default

extension VanMoofBikeBluetoothCharacteristic {
    
    /// The identifier.
    var id: String {
        Self.id
    }
    
    /// The value.
    var value: Data {
        .init()
    }
    
    /// Creates a new instance, if available.
    /// - Parameter value: The value.
    init?(value: Data) {
        nil
    }
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic+RawRepresentable<Double>

extension VanMoofBikeBluetoothCharacteristic where Self: RawRepresentable, Self.RawValue == Double {
    
    /// The value.
    var value: Data {
        Swift.withUnsafeBytes(of: self.rawValue) { Data($0) }
    }
    
    /// Creates a new instance, if available.
    /// - Parameter value: The value.
    init?(value: Data) {
        self.init(
            rawValue: value.withUnsafeBytes {
                $0.load(as: Double.self)
            }
        )
    }
    
}

// MARK: - VanMoofBikeBluetoothCharacteristic+RawRepresentable<String>

extension VanMoofBikeBluetoothCharacteristic where Self: RawRepresentable, Self.RawValue == String {
    
    /// The value.
    var value: Data {
        .init(self.rawValue.utf8)
    }
    
    /// Creates a new instance, if available.
    /// - Parameter value: The value.
    init?(value: Data) {
        self.init(
            rawValue: .init(decoding: value, as: UTF8.self)
        )
    }
    
}
