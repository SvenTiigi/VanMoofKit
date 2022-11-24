import SwiftUI
import VanMoofKit

// MARK: - BellSoundCard

extension BikeView {
    
    /// The BellSoundCard
    struct BellSoundCard {
        
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.BellSoundCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: .bell,
            title: "Bell Sound",
            systemImage: "bell.circle.fill",
            provider: {
                try await self.bike.bellSound
            },
            publisher: self.bike.bellSoundPublisher,
            content: { bellSound in
                ZStack {
                    bellSound
                        .icon
                        .font(.system(size: 120))
                        .opacity(0.2)
                        .offset(x: 50, y: 12)
                    HStack {
                        VStack {
                            Text(
                                verbatim: bellSound.localizedString
                            )
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.secondary)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.leading, 8)
                    .padding(.top, 40)
                }
            },
            actions: { currentBellSound in
                ForEach(VanMoof.Bike.BellSound.allCases, id: \.self) { bellSound in
                    Button {
                        Task {
                            try await self.bike.set(bellSound: bellSound)
                        }
                    } label: {
                        Label {
                            Text(
                                verbatim: bellSound.localizedString
                            )
                        } icon: {
                            if currentBellSound == bellSound {
                                Image(systemName: "checkmark")
                            } else {
                                bellSound.icon
                            }
                        }
                    }
                }
            }
        )
    }
    
}

private extension VanMoof.Bike.BellSound {
    
    var localizedString: String {
        "\(self)".capitalized
    }
    
}

private extension VanMoof.Bike.BellSound {
    
    var icon: Image {
        .init(
            systemName: {
                switch self {
                case .sonar:
                    return "rays"
                case .bell:
                    return "bell.fill"
                case .party:
                    return "party.popper.fill"
                case .foghorn:
                    return "sailboat.fill"
                }
            }()
        )
    }
    
}
