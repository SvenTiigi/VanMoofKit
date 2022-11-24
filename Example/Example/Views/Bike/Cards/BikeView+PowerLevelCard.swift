import SwiftUI
import VanMoofKit

// MARK: - PowerLevelCard

extension BikeView {
    
    /// The PowerLevelCard
    struct PowerLevelCard {
        
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.PowerLevelCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: .off,
            title: "Power Level",
            systemImage: "headlight.low.beam.fill",
            provider: {
                try await self.bike.powerLevel
            },
            publisher: self.bike.powerLevelPublisher,
            content: { powerLevel in
                Group {
                    if (1...4).contains(powerLevel.rawValue) {
                        Text(
                            verbatim: .init(powerLevel.rawValue)
                        )
                        .font(.system(size: 180).weight(.bold).italic())
                        .offset(y: 12)
                    } else {
                        Text(
                            verbatim: powerLevel.localizedString
                        )
                        .font(.system(size: 60).weight(.bold).italic())
                    }
                }
                .opacity(0.3)
            },
            actions: { currentPowerLevel in
                ForEach(
                    VanMoof.Bike.PowerLevel.allCases,
                    id: \.self
                ) { powerLevel in
                    Button {
                        Task {
                            try await self.bike.set(powerLevel: powerLevel)
                        }
                    } label: {
                        Label {
                            Text(
                                verbatim: powerLevel.localizedString
                            )
                        } icon: {
                            if currentPowerLevel == powerLevel {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        )
    }
    
}

private extension VanMoof.Bike.PowerLevel {
    
    var localizedString: String {
        switch self {
        case .off:
            return "Off"
        case .one:
            return "Level 1"
        case .two:
            return "Level 2"
        case .three:
            return "Level 3"
        case .four:
            return "Level 4"
        case .maximum:
            return "Max."
        }
    }
    
}
