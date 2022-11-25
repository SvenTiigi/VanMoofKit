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
                    value: speedLimit.measurement.value,
                    in: 0...37
                ) {
                    Text(verbatim: speedLimit.measurement.unit.symbol)
                } currentValueLabel: {
                    Text(verbatim: .init(Int(speedLimit.measurement.value)))
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
                                verbatim: "\(speedLimit.localizedString) (\(speedLimit.measurement.formatted()))"
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
