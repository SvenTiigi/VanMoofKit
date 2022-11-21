import Foundation

// MARK: - VanMoof+Bike+BluetoothServices

extension VanMoof.Bike {
 
    /// The VanMoof Bike Bluetooth Services
    enum BluetoothServices {}
    
}

// MARK: - VanMoof+Bike+BluetoothServices+all

extension VanMoof.Bike.BluetoothServices {
    
    /// All VanMoof Bike BluetoothServices
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
