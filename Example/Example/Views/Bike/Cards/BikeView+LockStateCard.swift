import SwiftUI
import VanMoofKit

// MARK: - LockStateCard

extension BikeView {
    
    /// The LockStateCard
    struct LockStateCard {
        
        /// The VanMoof Bike
        @EnvironmentObject
        private var bike: VanMoof.Bike
        
    }
    
}

// MARK: - View

extension BikeView.LockStateCard: View {
    
    /// The content and behavior of the view.
    var body: some View {
        BikeView.Card(
            placeholderValue: .locked,
            title: "Lock State",
            systemImage: "lock.circle.fill",
            provider: { try await self.bike.lockState },
            publisher: self.bike.lockStatePublisher,
            content: { lockState in
                lockState
                    .icon
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .font(.system(size: 110))
                    .opacity(0.2)
                    .offset(y: 25)
            },
            actions: { currentLockState in
                EmptyView()
            }
        )
    }
    
}

private extension VanMoof.Bike.LockState {
    
    var localizedString: String {
        switch self {
        case .unlocked:
            return "Unlocked"
        case .locked:
            return "Locked"
        case .awaitingUnlock:
            return "Awaiting unlock"
        }
    }
    
}

private extension VanMoof.Bike.LockState {
    
    var icon: Image {
        .init(
            systemName: {
                switch self {
                case .unlocked:
                    return "lock.open.fill"
                case .locked:
                    return "lock.fill"
                case .awaitingUnlock:
                    return "lock"
                }
            }()
        )
    }
    
}
