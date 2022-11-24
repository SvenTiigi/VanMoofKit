import SwiftUI
import VanMoofKit

// MARK: - PlaySoundCard

extension BikeView {
    
    /// The PlaySoundCard
    struct PlaySoundCard {
        
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.PlaySoundCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: 0,
            title: "Play Sound",
            systemImage: "play.fill",
            content: { _ in
                Image(
                    systemName: "play.circle.fill"
                )
                .font(.system(size: 125))
                .opacity(0.2)
                .offset(x: 50, y: 15)
            },
            actions: { _ in
                ForEach(
                    VanMoof.Bike.Sound.allCases,
                    id: \.self
                ) { sound in
                    Button {
                        Task {
                            try await self.bike.play(sound: sound)
                        }
                    } label: {
                        Text(verbatim: sound.localizedString)
                    }
                }
            }
        )
    }
    
}

private extension VanMoof.Bike.Sound {
    
    var localizedString: String {
        switch self {
        case .scrollingTone:
            return "Scrolling Tone"
        case .beepNegative:
            return "Beep Negative"
        case .beepPositive:
            return "Beep Positive"
        case .unlockCountdown:
            return "Unlock Countdown"
        case .pairing:
            return "Pairing"
        case .enterBackupCodeMode:
            return "Enter Backup Code Mode"
        case .resetCountdown:
            return "Reset Countdown"
        case .pairingSuccessful:
            return "Pairing Successful"
        case .pairingFailed:
            return "Pairing Failed"
        case .horn1:
            return "Horn 1"
        case .hornUrgent:
            return "Horn Urgen"
        case .lock:
            return "Lock"
        case .unlock:
            return "Unlock"
        case .alarmStageOne:
            return "Alarm Stage 1"
        case .alarmStageTwo:
            return "Alarm Stage 2"
        case .systemStartup:
            return "System Startup"
        case .systemShutdown:
            return "System Shutdown"
        case .charging:
            return "Charging"
        case .diagnose:
            return "Diagnose"
        case .firmwareDownload:
            return "Firmware Download"
        case .firmwareFailed:
            return "Firmware Failed"
        case .horn2:
            return "Horn 2"
        case .horn3:
            return "Horn 3"
        case .firmwareSuccessful:
            return "Firmware Successful"
        case .noise:
            return "Noise"
        case .unpairing:
            return "Unpairing"
        case .fmDisable:
            return "FM Disable"
        case .fmEnable:
            return "FM Enable"
        case .fmNoise:
            return "FM Noise"
        }
    }
    
}
