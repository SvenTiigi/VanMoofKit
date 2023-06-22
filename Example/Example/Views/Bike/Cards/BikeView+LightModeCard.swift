import SwiftUI
import VanMoofKit

// MARK: - LightModeCard

extension BikeView {
    
    /// The LightModeCard
    struct LightModeCard {
        
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
        @State
        private var selectedLightMode: VanMoof.Bike.LightMode?
        
    }
    
}

// MARK: - View

extension BikeView.LightModeCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            fixedHeight: 130,
            placeholderValue: .auto,
            provider: {
                try await self.bike.lightMode
            },
            publisher: self.bike.lightModePublisher,
            background: { _ in
                Color.foregroundColor
                Image("Street")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.5)
                    .blur(radius: 5)
                    .unredacted()
                    .scaleEffect(1.3)
            },
            content: { lightMode in
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            lightMode.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 105)
                                .offset(y: 10)
                                .unredacted()
                                .brightness(0.03)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(
                                verbatim: "Light Mode"
                            )
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding([.leading, .top], 5)
                            Spacer()
                            Label {
                                Text(verbatim: lightMode.localizedString)
                            } icon: {
                                lightMode.icon
                            }
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.leading)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            },
            actions: { currentLightMode in
                ForEach(
                    VanMoof.Bike.LightMode.allCases,
                    id: \.self
                ) { lightMode in
                    Button {
                        Task {
                            try await self.bike.set(lightMode: lightMode)
                        }
                    } label: {
                        Label {
                            Text(
                                verbatim: lightMode.localizedString
                            )
                        } icon: {
                            if currentLightMode == lightMode {
                                Image(systemName: "checkmark")
                            } else {
                                lightMode.icon
                            }
                        }
                    }
                }
            }
        )
    }
    
}

private extension VanMoof.Bike.LightMode {
    
    var localizedString: String {
        switch self {
        case .auto:
            return "Auto"
        case .alwaysOn:
            return "Always On"
        case .off:
            return "Lights off"
        }
    }
    
}

private extension VanMoof.Bike.LightMode {
    
    var image: Image {
        switch self {
        case .auto:
            return .init("LightModeAuto")
        case .alwaysOn:
            return .init("LightModeAlwaysOn")
        case .off:
            return .init("LightModeOff")
        }
    }
    
}

private extension VanMoof.Bike.LightMode {
    
    var icon: Image {
        Image(
            systemName: {
                switch self {
                case .auto:
                    return "auto.headlight.low.beam"
                case .alwaysOn:
                    return "headlight.low.beam.fill"
                case .off:
                    return "poweroff"
                }
            }()
        )
    }
    
}
