import Foundation

// MARK: - VanMoofBikeBluetoothService

/// A VanMoof Bike Bluetooth Service type
protocol VanMoofBikeBluetoothService: Sendable {
    
    /// The identifier.
    static var id: String { get }
    
    /// The characteristics.
    static var characteristics: [VanMoofBikeBluetoothCharacteristic.Type] { get }
    
}
