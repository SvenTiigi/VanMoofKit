import Foundation

// MARK: - VanMoof+Bike+Sound

public extension VanMoof.Bike {
    
    /// A VanMoof Bike Sound
    enum Sound: Int, Codable, Hashable, CaseIterable, Sendable {
        /// Scrolling Tone
        case scrollingTone = 1
        /// Beep Negative
        case beepNegative
        /// Beep Positive
        case beepPositive
        /// Unlock Countdown
        case unlockCountdown
        /// Pairing
        case pairing
        /// Enter Backup Code Mode
        case enterBackupCodeMode
        /// Reset Countdown
        case resetCountdown
        /// Pairing Successful
        case pairingSuccessful
        /// Pairing Failed
        case pairingFailed
        /// Horn 1
        case horn1
        /// Horn Urgent
        case hornUrgent
        /// Lock
        case lock
        /// Unlock
        case unlock
        /// Alarm Stage One
        case alarmStageOne
        /// Alarm Stage Two
        case alarmStageTwo
        /// System Startup
        case systemStartup
        /// System Shutdown
        case systemShutdown
        /// Charging
        case charging
        /// Diagnose
        case diagnose
        /// Firmware Download
        case firmwareDownload
        /// Firmware Failed
        case firmwareFailed
        /// Horn 2
        case horn2
        /// Horn 3
        case horn3
        /// Firmware Successful
        case firmwareSuccessful
        /// Noise
        case noise
        /// Unpairing
        case unpairing
        /// FM Disable
        case fmDisable
        /// FM Enable
        case fmEnable
        /// FM Noise
        case fmNoise
    }
    
}

// MARK: - VanMoof+Bike+play(sound:)

public extension VanMoof.Bike {
    
    /// Play a Sound.
    /// - Parameters:
    ///   - sound: The Sound which should be played.
    ///   - count: The number of times the Sound should be played. Default value `1`
    func play(
        sound: Sound,
        count: Int = 1
    ) async throws {
        try await self.bluetoothManager.write(
            characteristic: VanMoof
                .Bike
                .BluetoothServices
                .Sound
                .PlaySoundCharacteristic(
                    sound: .init(sound.rawValue),
                    count: .init(count)
                )
        )
    }
    
}
