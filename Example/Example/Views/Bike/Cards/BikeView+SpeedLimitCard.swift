import SwiftUI
import VanMoofKit

// MARK: - SpeedLimitCard

extension BikeView {
    
    /// The SpeedLimitCard
    struct SpeedLimitCard {
        
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.SpeedLimitCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: .europe,
            title: "Speed Limit",
            systemImage: "speedometer",
            provider: {
                try await self.bike.speedLimit
            },
            publisher: self.bike.speedLimitPublisher,
            content: { speedLimit in
                Gauge(
                    value: Double(speedLimit.maximumKilometersPerHour),
                    in: 0...37
                ) {
                    Text(verbatim: "km/h")
                } currentValueLabel: {
                    Text(verbatim: .init(speedLimit.maximumKilometersPerHour))
                }
                .scaleEffect(1.4)
                .gaugeStyle(.accessoryCircular)
                .tint(.teal)
            },
            actions: { currentSpeedLimit in
                ForEach(VanMoof.Bike.SpeedLimit.allCases, id: \.self) { speedLimit in
                    Button {
                        Task {
                            try await self.bike.set(speedLimit: speedLimit)
                        }
                    } label: {
                        Label {
                            Text(
                                verbatim: "\(speedLimit.localizedString) (\(speedLimit.maximumKilometersPerHour) km/h)"
                            )
                        } icon: {
                            if currentSpeedLimit == speedLimit {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        )
    }
    
}

private extension VanMoof.Bike.SpeedLimit {
    
    var localizedString: String {
        switch self {
        case .europe:
            return "Europe"
        case .unitedStates:
            return "United States"
        case .japan:
            return "Japan"
        }
    }
    
}
