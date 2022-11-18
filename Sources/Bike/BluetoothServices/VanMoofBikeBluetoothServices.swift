import Foundation

// MARK: - VanMoofBikeBluetoothServices

/// The VanMoof Bike Bluetooth Services
enum VanMoofBikeBluetoothServices {}

// MARK: - VanMoofBikeBluetoothServices+all

extension VanMoofBikeBluetoothServices {
    
    /// All VanMoofBikeBluetoothServices
    static var all: [VanMoofBikeBluetoothService.Type] {
        [
            Security.self,
            Firmware.self,
            Defence.self,
            Movement.self,
            Info.self,
            State.self,
            Sound.self,
            Light.self,
            Maintenance.self
        ]
    }
    
}
