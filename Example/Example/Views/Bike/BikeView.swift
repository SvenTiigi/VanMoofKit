import AppIntents
import SwiftUI
import VanMoofKit

// MARK: - BikeView

/// The BikeView
struct BikeView {
    
    /// The VanMoof Bike
    @ObservedObject
    var bike: VanMoof.Bike
    
}

// MARK: - View

extension BikeView: View {
    
    /// The content and behavior of the view.
    var body: some View {
        ScrollView {
            VStack {
                ConnectionView()
                    .unredacted()
                HStack {
                    LockStateCard()
                    BatteryLevelCard()
                }
                HStack {
                    SpeedLimitCard()
                    PowerLevelCard()
                }
                HStack {
                    SiriTipView(
                        intent: SetSpeedLimitIntent()
                    )
                    Spacer()
                    SiriTipView(
                        intent: SetPowerLevelIntent()
                    )
                }
                .padding(.vertical, 7)
                LightModeCard()
                HStack {
                    BellSoundCard()
                    PlaySoundCard()
                }
                FirmwareCard()
            }
            .padding(.horizontal)
            .redacted(
                reason: !self.bike.isConnected ? .placeholder : .init()
            )
        }
        .navigationTitle(self.bike.name)
        .animation(
            .default,
            value: self.bike.connectionState
        )
        .environmentObject(self.bike)
    }
    
}
